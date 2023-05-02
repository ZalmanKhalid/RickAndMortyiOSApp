//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Salman Khalid on 2023-04-25.
//

import UIKit


/// Controller to huse tab and root tab view controller 
class RMTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupTabs()
    }

    private func setupTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let settingsVC = RMSettingsViewController()
        let episodeVC = RMEpisodeViewController()
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Character", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Episode", image: UIImage(systemName: "gear"), tag: 4)
        

        let navControllers = [nav1,nav2,nav3,nav4]
        for nav in navControllers {
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers(navControllers, animated: true)
    }

}

