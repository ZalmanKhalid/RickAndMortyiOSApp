//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-08.
//

import Foundation

class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var name: String {
        return self.character.name.uppercased()
    }
}
