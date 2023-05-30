//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-30.
//

import UIKit

class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    
    //MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    private func fetchEpisodeData(){
        
        guard let endpointUrl,
              let request = RMRequest(url: endpointUrl) else {
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }

}
