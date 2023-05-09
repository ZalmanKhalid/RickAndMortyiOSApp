//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-08.
//

import UIKit

/// Controller to show Info about Selected Character
class RMCharacterDetailViewController: UIViewController {

    private var viewModel:RMCharacterDetailViewViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.name
    }
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
