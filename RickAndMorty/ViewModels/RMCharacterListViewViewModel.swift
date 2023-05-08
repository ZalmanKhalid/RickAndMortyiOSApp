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
}

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
    
    public func fectchCharacters(){
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
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
//        let imgUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/11.jpeg")
//        let viewModel = RMCharacterCollectionViewCellViewModel( characterName: "zalman",
//                                                                characterStatus: .alive,
//                                                                characterImageUrl: imgUrl)
        let viewModel = self.cellViewModels[indexPath.item]
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width*1.5)
    }
    
}

