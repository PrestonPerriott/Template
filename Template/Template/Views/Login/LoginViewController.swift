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

    @IBOutlet weak var usernameTextField: FloatField!
    @IBOutlet weak var emailTextfield: FloatField!
    @IBOutlet weak var passwordTextfield: FloatField!
    @IBOutlet weak var registrationSegmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordBottomConstraint: NSLayoutConstraint!
    
    private let controller = LoginController()
    private weak var keyboard = IQKeyboardManager.sharedManager()
    private var initalConstant = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guiSetup()
        delegationSetUp()
        usernameTextField.isHidden = true
        keyboard?.shouldResignOnTouchOutside = true
        keyboard?.preventShowingBottomBlankSpace = true
        initalConstant = passwordBottomConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDidShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func usernameTextFieldEdited(_ sender: FloatField) {
        guard let text = sender.text else {
            return
        }
        sender.bottomBorder.backgroundColor = sender.updateBorder(text: text)
    }
    
    @IBAction func emailTextFieldEdited(_ sender: FloatField) {
        guard let text = sender.text else {
            return
        }
        sender.bottomBorder.backgroundColor = sender.updateBorder(text: text)
    }
    @IBAction func passwordTextFieldEdited(_ sender: FloatField) {
        guard let text = sender.text else {
            return
        }
        sender.bottomBorder.backgroundColor = sender.updateBorder(text: text)
    }
    
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case "Register":
            print("Pressed Register")
            ///Code for registering
            AuthenticationService.register(username: usernameTextField.text ?? "", password: passwordTextfield.text ?? "", email: emailTextfield.text ?? "", completion: {(result) in
                if let err = result.err {
                    
                    print("Our error is : \(err.localizedDescription)")
                } else {
                    let mainCont = MainTabViewController()
                    self.present(mainCont, animated: true, completion: nil)
                }
            })
            break
        case "Login":
            print("Pressed Login")
            ///Code for logging in
            AuthenticationService.login(password: passwordTextfield.text ?? "", email: emailTextfield.text ?? "", completion: {(result) in
                if let err = result.err {
                    
                    print("Our error is : \(err.localizedDescription)")
                } else {
                    let mainCont = MainTabViewController()
                    self.present(mainCont, animated: true, completion: nil)
                }
            })
            break
        default:
            print("Default invoked, error")
        }
    }
}

extension LoginViewController: LoginControllerDelegate {
   
    private func guiSetup() {
        loginButton.styleBorder()
    }
    
    @objc func tappedSegment(_ sender: UISegmentedControl) {
        loginButton.setTitle(registrationSegmentControl.titleForSegment(at: registrationSegmentControl.selectedSegmentIndex), for: .normal)
        usernameTextField.isHidden = registrationSegmentControl.selectedSegmentIndex == 0 ? true : false
    }
    
    private func delegationSetUp() {
        controller.delegate = self
        emailTextfield.delegate = controller
        emailTextfield.type = .email
        emailTextfield.placeholder = "Email"
        passwordTextfield.delegate = controller
        passwordTextfield.type = .password
        passwordTextfield.placeholder = "Password"
        usernameTextField.delegate = controller
        usernameTextField.type = .username
        emailTextfield.tag = 1
        passwordTextfield.tag = 2
        
        registrationSegmentControl.addTarget(self, action: #selector(tappedSegment), for: .valueChanged)
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
