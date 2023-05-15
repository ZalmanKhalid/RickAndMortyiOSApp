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
    private let pathComponents: [String]
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
                return "\($0.name)=\(value)"
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
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: constants.baseUrl+"/", with: "")
        
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endPointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endPointString){
                    self.init(endPoint: rmEndpoint)
                    return
                }
                    
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endPointString = components[0]
                let queryItemString = components[1]
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else { return nil }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let rmEndpoint = RMEndpoint(rawValue: endPointString){
                    self.init(endPoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
                    
            }
        }
        
        return nil
        
        
    }
}


extension RMRequest {
    
    static let listCharactersRequest = RMRequest(endPoint: .character)
    
}
