//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-08.
//

import Foundation
import UIKit

class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter

    public var episeodes: [String] {
        character.episode
    }
    
    enum SectionTypes {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        
        case info(viewModel: [RMCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModel: [RMCharacterEpisodesCollectionViewCellViewModel])
    }
    
    public var sections: [SectionTypes] = []
    
    //MARK: - Init
    
    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }
    
    private func setupSections() {
        sections = [
            
            .photo(viewModel: .init(imageUrl: URL(string: character.image)) ),
            
                .info(viewModel: [
                    .init(type: .status, value: character.status.text),
                    .init(type: .gender, value: character.gender.rawValue),
                    .init(type: .type, value: character.type),
                    .init(type: .species, value: character.species),
                    .init(type: .origin, value: character.origin.name),
                    .init(type: .location, value: character.location.name),
                    .init(type: .created, value: character.created),
                    .init(type: .episodeCount, value: "\(character.episode.count)")
                ]),
            
                .episodes(viewModel: character.episode.map({
                    return RMCharacterEpisodesCollectionViewCellViewModel(episodeDataUrl: URL(string: $0) )
                }) )
        ]
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var name: String {
        return self.character.name.uppercased()
    }
    
    //MARK: - collectionView layouts
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 2,
            trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            ),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 4,
            bottom: 8,
            trailing: 6)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.85),
                heightDimension: .absolute(150)
            ),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    /*
     // not needed since we already have the character model with all info 
    public func fetchCharacterData(){
        
        guard let url = requestUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMCharacter.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }
    */
}
