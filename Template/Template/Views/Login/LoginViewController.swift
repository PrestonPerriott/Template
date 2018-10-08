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

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordBottomConstraint: NSLayoutConstraint!
    /// TODO: Login Button
    
    private let controller = LoginController()
    private weak var keyboard = IQKeyboardManager.sharedManager()
    private var initalConstant = CGFloat()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guiSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegationSetUp()
        keyboard?.shouldResignOnTouchOutside = true
        initalConstant = passwordBottomConstraint.constant
        
        if let env = Bundle.main.infoDictionary?["node_api_endpoint"] {
            print("Our env is : \(env)")
        } else {
            print("Please set env variable")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func didTouchUsernameField(_ sender: UITextField) {
        keyboard?.preventShowingBottomBlankSpace = true
    }
    @IBAction func didTouchPasswordField(_ sender: UITextField) {
        keyboard?.preventShowingBottomBlankSpace = true
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    self.passwordBottomConstraint.constant = initalConstant
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            })
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.passwordBottomConstraint.constant = keyboardFrame.size.height + 10
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension LoginViewController: LoginControllerDelegate {
    
    func login(with email: String, password: String, completion: @escaping ((CompletionResults<Any>) -> Void)) {
        ///TODO: Realm logic for validating user
    }
    
    private func guiSetup() {
        emailTextfield.styleBorder()
        passwordTextfield.styleBorder()
    }
    
    private func delegationSetUp() {
        controller.delegate = self
        emailTextfield.delegate = controller
        passwordTextfield.delegate = controller
        emailTextfield.tag = 1
        passwordTextfield.tag = 2
    }
}
