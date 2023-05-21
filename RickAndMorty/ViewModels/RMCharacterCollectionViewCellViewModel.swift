//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-07.
//

import Foundation

class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    public let characterName: String
//    public let characterID: Int
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?
            
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    init(
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data,Error>)->Void ){
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(url, completion: completion)
    }
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
