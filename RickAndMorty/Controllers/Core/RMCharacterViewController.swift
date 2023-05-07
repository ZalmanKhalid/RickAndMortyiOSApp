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
          
        /*
        let request = RMRequest(
            endPoint: .character,
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive")
            ]
        )
        
        //print(request.url)
        
        RMService.shared.execute(request, expecting: RMCharacter.self) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        */
        
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharacterResponse.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
                print(model.info.count)
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
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
