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
}
    
extension LoginController: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textFieldWillShift(textField, distance: -210, up: true)
        }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textFieldWillShift(textField, distance: -210, up: false)
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
