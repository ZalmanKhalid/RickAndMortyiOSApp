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
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    private let cacheManager = RMAPICacheManager()
    
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
        if let ChachedData = cacheManager.cachedResponse(
            for: request.endPoint,
            url: request.url) {
            print("using cached api response")
            do{
                let result = try JSONDecoder().decode(type.self, from: ChachedData)
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // decode json
            do{
                //let json = try JSONSerialization.jsonObject(with: data)
                //print(String(describing: json))
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
                self?.cacheManager.setCache(
                    for: request.endPoint,
                    url: request.url,
                    data: data)
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: private
    private func request(from rmequest: RMRequest) -> URLRequest? {
        guard let url = rmequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
