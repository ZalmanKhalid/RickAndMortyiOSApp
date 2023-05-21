//
//  ImageManager.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-21.
//

import Foundation

final class RMImageManager {
    static let shared = RMImageManager()
    private var imageDataChache = NSCache<NSString, NSData>()
    private init() {}
    
    
    /// Get image content with url
    /// - Parameters:
    ///   - url: image url
    ///   - completion: callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data,Error>)->Void ){
       
        let key = url.absoluteString as NSString
        if let imagaData = imageDataChache.object(forKey: key){
            completion(.success(imagaData as Data))
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, __, error in
            guard let data = data, error == nil else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let imageData = data as NSData
            self?.imageDataChache.setObject(imageData, forKey: key)
            completion(.success(data))
        }
        task.resume()

    }
}
