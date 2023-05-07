//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-07.
//

import Foundation
import UIKit

final class RMCharacterListViewViewModel: NSObject {
    
    func fectchCharacters(){
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharacterResponse.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
                print(model.info.count)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}

// i personally like this following to be a part of controller 
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("unSupportedCell")
        }
        let imgUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/11.jpeg")
        let viewModel = RMCharacterCollectionViewCellViewModel( characterName: "zalman",
                                                                characterStatus: .alive,
                                                                characterImageUrl: imgUrl)
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width*1.5)
    }
    
}

