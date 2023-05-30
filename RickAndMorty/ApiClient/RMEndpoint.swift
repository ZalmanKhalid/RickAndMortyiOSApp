//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-02.
//

import Foundation


/// Represent unique API endpoints
@frozen enum RMEndpoint: String, Hashable, CaseIterable {
    ///Endpoints to get character info
    case character
    ///Endpoints to get lopcation info
    case lopcation
    ///Endpoints to get episode info
    case episode
    
}
