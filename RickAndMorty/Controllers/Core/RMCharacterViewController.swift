//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-27.
//

import UIKit

/// controller to and sreach for characters
class RMCharacterViewController: UIViewController {

    private let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Character"
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.view.addSubview(characterListView)
        addConstraints()
        characterListView.delegate = self
    }
    
    fileprivate func addConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}

extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        // open detail controller for character
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailViewController = RMCharacterDetailViewController(viewModel: viewModel)
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}
