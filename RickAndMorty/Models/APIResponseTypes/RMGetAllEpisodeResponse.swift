//
//  RMGetAllEpisodeResponse.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-06-01.
//

import Foundation

struct RMGetAllEpisodeResponse: Codable {
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
