//
//  ViewController.swift
//  NetflixClone
//
//  Created by developer on 6/6/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.superview?.backgroundColor = .black
        view.backgroundColor = .black
        tabBar.tintColor = .label
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: DownloadsViewController())
        let vc4 = UINavigationController(rootViewController: UpcomingsViewController())
        
        // tab bar icons
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        vc4.tabBarItem.image = UIImage(systemName: "play.circle")
        
        // tab bars titles
        
        vc1.title = "Home"
        vc2.title = "Top Search"
        vc3.title = "Download"
        vc4.title = "Coming Soon"
        
        
        setViewControllers([vc1, vc4, vc2, vc3], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

