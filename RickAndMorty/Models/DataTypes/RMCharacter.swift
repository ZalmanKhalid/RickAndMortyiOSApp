//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-25.
//

import Foundation


// MARK: - RMCharacter
struct RMCharacter: Codable {
    let id: Int
    let name: String
    let species: String
    let type: String
    let status: RMCharacterStatus
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - RMSingleLocation
struct RMSingleLocation: Codable {
    let name: String
    let url: String
}

// MARK: - RMOrigin
struct RMOrigin: Codable {
    let name: String
    let url: String
}

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum RMCharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}
