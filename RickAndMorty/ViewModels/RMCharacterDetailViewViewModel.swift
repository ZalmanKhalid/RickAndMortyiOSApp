//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-08.
//

import Foundation

class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    enum sectionTypes: CaseIterable {
        case photo
        case info
        case episodes
    }
    
    public let sections = sectionTypes.allCases
    
    //MARK: - Init
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var name: String {
        return self.character.name.uppercased()
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
