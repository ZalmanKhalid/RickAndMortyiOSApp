//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-27.
//

import UIKit

/// controller to and sreach for location
class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Location"
        self.navigationItem.largeTitleDisplayMode = .automatic
        addSearchButton()
    }
    
    private func addSearchButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    

}
