//
//  RMCharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-25.
//

import Foundation
import UIKit


protocol RMEpisodesDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodesCollectionViewCellViewModel: Hashable, Equatable {
    
    let episodeDataUrl: URL?
    public let borderColor: UIColor
    private var isFetching = false
    private var dataBlock: ((RMEpisodesDataRender) -> Void)?
    private var episeode: RMEpisode? {
        didSet{
            guard let model = episeode else { return }
            dataBlock?(model)
        }
    }
    
    //MARK: - Init
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemMint) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: - Public
    
    public func registerForData(_ block: @escaping(RMEpisodesDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode(){
        guard !isFetching else {
            if let model = episeode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl,
        let request = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] results in
            switch results {
            case .success(let episode):
                DispatchQueue.main.async {
                    self?.episeode = episode
                }
                //print(String(describing: episode.id))
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
        
    }
    
    static func == (lhs: RMCharacterEpisodesCollectionViewCellViewModel, rhs: RMCharacterEpisodesCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
