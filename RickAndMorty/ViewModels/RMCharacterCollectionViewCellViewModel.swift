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
//        characterID: Int,
        characterStatus: RMCharacterStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
//        self.characterID = characterID
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public func fetch(completion: @escaping (Result<Data,Error>)->Void ){
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, __, error in
            guard let data = data, error == nil else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
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
