//
//  RMService.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-02.
//

// Responsible for making api calls

import Foundation

/// Primary API sevice objetct to get Rick and Morty Data
final class RMService {
    
    /// signleton method
    static let shared = RMService()
    
    /// privatetised constructor
    private init() {}
    
    
    /// Make Rick and Morty call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,Error>)->Void
    ) {
        
    }
}
