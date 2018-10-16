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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registrationSegmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordBottomConstraint: NSLayoutConstraint!
    
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
        usernameTextField.isHidden = true
        keyboard?.shouldResignOnTouchOutside = true
        initalConstant = passwordBottomConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDidShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func didTouchUsernameField(_ sender: UITextField) {
        keyboard?.preventShowingBottomBlankSpace = true
    }
    @IBAction func didTouchPasswordField(_ sender: UITextField) {
        keyboard?.preventShowingBottomBlankSpace = true
    }
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case "Register":
            print("Pressed Register")
            ///Code for registering
            break
        case "Login":
            print("Pressed Login")
            ///Code for logging in
        default:
            print("Default invoked, error")
        }
    }
}

extension LoginViewController: LoginControllerDelegate {
   
    private func guiSetup() {
        usernameTextField.styleBorder()
        emailTextfield.styleBorder()
        passwordTextfield.styleBorder()
        loginButton.styleBorder()
        registrationSegmentControl.addTarget(self, action: #selector(tappedSegment), for: .valueChanged)
    }
    
    @objc func tappedSegment(_ sender: UISegmentedControl) {
        loginButton.setTitle(registrationSegmentControl.titleForSegment(at: registrationSegmentControl.selectedSegmentIndex), for: .normal)
        usernameTextField.isHidden = registrationSegmentControl.selectedSegmentIndex == 0 ? true : false
    }
    
    private func delegationSetUp() {
        controller.delegate = self
        emailTextfield.delegate = controller
        passwordTextfield.delegate = controller
        emailTextfield.tag = 1
        passwordTextfield.tag = 2
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let _: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.passwordBottomConstraint.constant = initalConstant
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardDidShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.passwordBottomConstraint.constant = keyboardFrame.size.height + 10
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
