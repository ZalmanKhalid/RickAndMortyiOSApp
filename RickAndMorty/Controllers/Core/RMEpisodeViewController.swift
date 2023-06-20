//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-27.
//

import UIKit

/// controller to and sreach for episode
class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Episode"
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.view.addSubview(episodeListView)
        addConstraints()
        episodeListView.delegate = self
        addSearchButton()
    }
    
    private func addSearchButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    fileprivate func addConstraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ characterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // open detail controller for episode
        //let viewModel = RMEpisodeDetailViewViewModel(endpointUrl: URL(string: episode.url))
        let detailViewController = RMEpiseodeDetailViewController(url: URL(string: episode.url))
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
//    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
//        // open detail controller for character
//        let viewModel = RMCharacterDetailViewViewModel(character: character)
//        let detailViewController = RMCharacterDetailViewController(viewModel: viewModel)
//        detailViewController.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(detailViewController, animated: true)
//    }
    
    
    
}
