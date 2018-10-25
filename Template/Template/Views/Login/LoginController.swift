//
//  LoginController.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

protocol LoginControllerDelegate: class {
    
}

class LoginController: NSObject {
    
    weak var delegate: LoginControllerDelegate?
    
    ///OR if we want to keep the logic here
    func login(with email: String, password: String, completion: @escaping NetworkCompletion<User>) {
        
        AuthenticationService.login(password: password, email: email, completion: {(results) in
            if let user = results.res {
                do {
                    ///TODO: Even tho we say user, object hasn't been created in Node yet!!
                     try RealmService.shared.save(user)
                    completion(NetworkResults(err: nil, res: user))
                } catch {
                    let err =  NSError(domain: "Failed to Save to Realm", code: 5000, userInfo: nil)
                    completion(NetworkResults(err: results.err ?? err, res: nil))
                }
            }
        })
    }
    
    func register(with username: String, email: String, password: String, completion: @escaping NetworkCompletion<User>) {
        
        AuthenticationService.register(username: username, password: password, email: email, completion: {(results) in
            if let user = results.res {
                do {
                    try RealmService.shared.save(user)
                    completion(NetworkResults(err: nil, res: user))
                } catch {
                    let err =  NSError(domain: "Failed to Save to Realm", code: 5000, userInfo: nil)
                    completion(NetworkResults(err: results.err ?? err, res: nil))
                }
            }
        })
    }
}
    
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
