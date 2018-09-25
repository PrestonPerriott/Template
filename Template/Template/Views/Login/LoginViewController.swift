//
//  LoginViewController.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    private let controller = LoginController()
    private var keyboard = IQKeyboardManager.sharedManager()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guiSetup()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegationSetUp()
        controller.delegate = self
    }
    @IBAction func didTouchUsernameField(_ sender: UITextField) {
        keyboard.preventShowingBottomBlankSpace = true
    }
    @IBAction func didTouchPasswordField(_ sender: UITextField) {
        keyboard.preventShowingBottomBlankSpace = true
    }
}

extension LoginViewController: LoginControllerDelegate {
    
    private func guiSetup() {
        emailTextfield.styleBorder()
        passwordTextfield.styleBorder()
    }
    
    private func delegationSetUp() {
        emailTextfield.delegate = controller
        passwordTextfield.delegate = controller
        emailTextfield.tag = 1
        passwordTextfield.tag = 2
        
        keyboard.shouldResignOnTouchOutside = true
    }
}
