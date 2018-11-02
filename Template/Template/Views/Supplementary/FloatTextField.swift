//
//  UITextfield+Style.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType: String {
    case email = "email"
    case password = "password"
    case username = "username"
    case none = "none"
}

class FloatField : UITextField, UITextFieldDelegate {
    
    var bottomBorder = UIView()
    var lowerBorder = UIView()
    var type: TextFieldType = .none
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func awakeFromNib() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.white // Set Border-Color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 0.75).isActive = true // Set Border-Strength

    }
    
    func updateBorder(text: String) -> UIColor {
        switch type {
        case .email:
            return text.isValidEmail() ? UIColor.white : UIColor.red
        case .username:
            return text.isValidUsername() ? UIColor.white : UIColor.red
        case .password:
            return text.isValidPassword() ? UIColor.white : UIColor.red
        case .none:
            return UIColor.white
        }
    }
}
