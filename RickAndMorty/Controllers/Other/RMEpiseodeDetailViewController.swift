//
//  RMEpiseodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-05-30.
//

import UIKit

final class RMEpiseodeDetailViewController: UIViewController {

    private let viewModel: RMEpisodeDetailViewViewModel
    
    //MARK: - Init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel.init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episeode"
        view.backgroundColor = .systemCyan
    }

}
