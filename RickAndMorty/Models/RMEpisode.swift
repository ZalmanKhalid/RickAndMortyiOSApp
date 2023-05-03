//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-25.
//

import Foundation


// MARK: - RMEpisode
struct RMEpisode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

