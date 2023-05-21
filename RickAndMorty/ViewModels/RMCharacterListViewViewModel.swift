//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-07.
//

import Foundation
import UIKit

protocol RMCharacterListViewViewModelDelagate: AnyObject {
    func didLoadInitialCharacter()
    func didLoadMoreCharacter(with newIndexPaths: [IndexPath])
    
    func didSelectCharacter(_ charater: RMCharacter)
}

/// ViewModel to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelagate?
    
    private var characters: [RMCharacter] = [] {
        didSet{
            for character in characters {
                let cellViewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
//                    characterID: character.id,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image) )
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
            
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllCharacterResponse.Info?
    
    private var isloadingMoreCharacters: Bool = false
    
    /// Fecth Initial set of characters
    public func fectchCharacters(){
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacter()
                }
                //print(String(describing: model))
                //print(model.info.count)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// paginate if addiotional characters are needed
    public func fectchAddiotionalCharacters(Url: URL){
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
                                 expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            guard let strongSelf = self else {  return }
            print("Characters Fetched")
            switch result {
            case .success(let responseModel):
//                print(String(describing: responseModel))
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info

                let orignalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = orignalCount+newCount
                let startingIndex = total-newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(item: $0, section: 0)
                })
                
                strongSelf.characters.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacter(with: indexPathToAdd)
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
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("unSupportedCell")
        }

        let viewModel = self.cellViewModels[indexPath.row]
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
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


extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    
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
                self?.fectchAddiotionalCharacters(Url: url)
            }
            t.invalidate()
        }
    }
}

