//
//  MainTabViewController.swift
//  Template
//
//  Created by Preston Perriott on 10/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class MainTabViewController: UINavigationController {

    let barController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTabController()
        barController.tabBar.barTintColor = UIColor.black
        barController.selectedIndex = 0
    }
}

extension MainTabViewController {
    
    private func createTabController() {
        let home = formNavController("Home", "HomeViewController", HomeViewController.self)
        home.tabBarItem.title = "Recipes"
        home.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        home.navigationBar.barTintColor = UIColor.black
        home.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 17)]
        home.navigationBar.tintColor = UIColor.white
        
        barController.setViewControllers([home], animated: true)
        self.view.addSubview(barController.view)
    }
}
