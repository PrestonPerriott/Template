//
//  MainTabViewController.swift
//  Template
//
//  Created by Preston Perriott on 10/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit
import MediumMenu

class MainTabViewController: UINavigationController {

    let barController = UITabBarController()
    var menu = MediumMenu()
    
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
        home.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        home.tabBarItem.title = "Recipes"
        /// https://stackoverflow.com/questions/29092988/leftbarbuttonitem-does-not-show-up-in-the-navigation-bar
        home.navigationBar.topItem?.title = "Recipes"
        home.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(showMenu))
        
        
        setUpMenu()
        barController.setViewControllers([home], animated: true)
        self.view.addSubview(barController.view)
    }
    
    private func setUpMenu() {
        
        let options = ["Home", "Profile","Settings","Subscription","Log Out"]
        var items = [MediumMenuItem]()
        
        for item in 0..<options.count {
            items.append(MediumMenuItem(title: options[item]){
                
                /// Logic for setting View Controllers for menu option
                switch options[item] {
                case _ where options[item] == "Home" :
                    print("Hit Home")
                case _ where options[item] == "Profile":
                    print("Hit profile")
                case _ where options[item] == "Settings":
                    print("Hit settings")
                case _ where options[item] == "Subscription":
                    print("Hit subscription")
                case _ where options[item] == "Log Out":
                    print("Hit log out")
                    NotificationCenter.default.post(name: .appContextLogout, object: self)
                default:
                    print("Should do nothing")
                }
            })
        }
        menu = MediumMenu(items: items, forViewController: self)
        menu.height = 300
        menu.animationDuration = 0.35
    }
    
    @objc func showMenu() {
        print("pressed side menu button")
        menu.show()
    }
}
