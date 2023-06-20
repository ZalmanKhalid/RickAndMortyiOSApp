//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-06-01.
//

import Foundation
import UIKit

protocol RMEpisodeListViewViewModelDelagate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    
    func didSelectEpisode(_ episode: RMEpisode)
}

/// ViewModel to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelagate?
    
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemRed,
        .systemPurple,
        .systemPink,
        .systemIndigo,
        .systemCyan,
        .systemGreen,
        .systemMint,
        .systemYellow,
        .systemOrange,
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet{
            for episode in episodes {
                let cellViewModel = RMCharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemMint )
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
            
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodesCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllEpisodeResponse.Info?
    
    private var isloadingMoreCharacters: Bool = false
    
    /// Fecth Initial set of episodes
    public func fetchEpisodes(){
        RMService.shared.execute(.listEpisodesRequest, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
                //print(String(describing: model))
                //print(model.info.count)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// paginate if addiotional episodes are needed
    public func fetchAddiotionalEpisodes(Url: URL){
        // fetch characters here
        guard !isloadingMoreCharacters else { return }
        isloadingMoreCharacters = true
        print("Fetching more Characters")
        guard let request = RMRequest(url: Url) else {
            isloadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            guard let strongSelf = self else {  return }
            print("Characters Fetched")
            switch result {
            case .success(let responseModel):
//                print(String(describing: responseModel))
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info

                let orignalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = orignalCount+newCount
                let startingIndex = total-newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(item: $0, section: 0)
                })
                
                strongSelf.episodes.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    strongSelf.isloadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isloadingMoreCharacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicatore: Bool {
        return self.apiInfo?.next != nil
    }
}

// i personally like this following to be a part of controller
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodesCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodesCollectionViewCell else {
            fatalError("unSupportedCell")
        }

        let viewModel = self.cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.width-20
        return CGSize(width: width, height: 100) //CGSize(width: width, height: width*0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicatore else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}


extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicatore,
              !isloadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString)
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewHeight = scrollView.frame.size.height
            
            if offset>0, offset >= (totalContentHeight - totalScrollViewHeight-120) {
                //print("start fetch more")
                self?.fetchAddiotionalEpisodes(Url: url)
            }
            t.invalidate()
        }
    }
}
