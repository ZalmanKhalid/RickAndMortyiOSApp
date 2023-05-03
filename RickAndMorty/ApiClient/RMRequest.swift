//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-02.
//

import Foundation


/// Object that represents a single api call
final class RMRequest {
    
    //base url
    // endpoint
    // path components
    // query params
    
    private struct constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    private let endPoint: RMEndpoint
    private let pathComponents: Set<String>
    private let queryParameters: [URLQueryItem]
    
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = constants.baseUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            //name=value&name=value
//            queryParameters.forEach({
//                guard let value = $0.value else { return }
//                string += "/\($0.name)=\(value)"
//            })
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "/\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(endPoint: RMEndpoint,
                pathComponents: Set<String> = [],
                queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}
