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
    ///TODO: Type any for now, but expecting a user
    func login(with email: String, password: String, completion: @escaping CompletionHelper<Any>)
}

class LoginController: NSObject {
    
    weak var delegate: LoginControllerDelegate?
}
    
extension LoginController: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
        }
    }
