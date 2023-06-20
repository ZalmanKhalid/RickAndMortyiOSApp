//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-30.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelagate: AnyObject {
    func didFetchEpisodeDetails()
}

class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet{
            createCellViewModels()
            self.delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [ RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    weak var delegate: RMEpisodeDetailViewViewModelDelagate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
    //MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    //MARK: - private
    private func createCellViewModels() {
        guard let dataTuple else { return }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: episode.created),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }
    
    //MARK: - public
    /// Fetch backing episode model
    public func fetchEpisodeData(){
        
        guard let endpointUrl,
              let request = RMRequest(url: endpointUrl) else {
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                print(String(describing: model))
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }
    
    public func fetchRelatedCharacters(episode: RMEpisode) {
        
        //let characterUrls = episode.characters.compactMap({ URL(string: $0) })
        //let requests = characterUrls.compactMap({ RMRequest(url: $0) })
        //above 2 lines can be written as 1 below
        let requests = episode.characters.compactMap({
            URL(string: $0)
        }).compactMap({
            RMRequest(url: $0)
        })
        
        //using dispatch group
        
        //10 paraller requests
        //notify once all done
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                    //print(String(describing: model))
                case .failure(_):
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (episode:episode, characters:characters)
        }
    }

}
