//
//  UIViewController+Navigation.swift
//  Template
//
//  Created by Preston Perriott on 10/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func formNavController<T: UIViewController>( _ name: String, _ id: String, _ type: T.Type) -> UINavigationController {
        let controller: T = UIStoryboard(name: name , bundle: nil).instantiateViewController(withIdentifier: id) as! T
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.barTintColor = UIColor.black
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 21)]

       return nav
    }
}
