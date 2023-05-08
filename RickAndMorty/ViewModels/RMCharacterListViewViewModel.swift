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
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image) )
                cellViewModels.append(cellViewModel)
            }
            
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllCharacterResponse.Info?
    
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
    public func fectchAddiotionalCharacters(){
        // fetch characters here
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
    
}

