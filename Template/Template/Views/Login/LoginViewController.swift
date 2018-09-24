//
//  LoginViewController.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    private let controller = LoginController()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guiSetup()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
}

extension LoginViewController {
    
    private func guiSetup() {
        emailTextfield.styleBorder()
        passwordTextfield.styleBorder()
        
        emailTextfield.placeholder = "Email"
        passwordTextfield.placeholder = "Password"
    }
}
