//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-25.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
