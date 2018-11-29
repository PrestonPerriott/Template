//
//  AppDelegate.swift
//  Template
//
//  Created by Preston Perriott on 9/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var entryPoint: UIViewController {
        var main = UIViewController()
        if AuthenticationService.isLoggedIn() {
            main = MainTabViewController()
        } else {
            main = UIStoryboard(name: "Login" , bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        return main
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        // Override point for customization after application launch.
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultAnimationType(.flat)
        registerNotifications()
        disolve(with: entryPoint)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        disolve(with: entryPoint)
    }
}

extension AppDelegate {
    
    private func registerNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(logOut), name: .appContextLogout, object: nil)
    }
    
    @objc private func logOut() {
        do {
            try AuthenticationService.logout()
            disolve(with: entryPoint)
        } catch {
            print("there was an error logging out!")
        }
    }
    
    private func disolve(with viewController: UIViewController) {
        
        guard let window = UIApplication.shared.keyWindow, let rootVC = window.rootViewController else {
            return
        }
    
        let vc = viewController
        vc.view.frame = rootVC.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            print("Completed transition")
        })
    }
}

