//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-27.
//

import UIKit

/// controller to and sreach for characters
class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Character"
        self.navigationItem.largeTitleDisplayMode = .automatic
                
        let request = RMRequest(
            endPoint: .character,
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        
        print(request.url)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
