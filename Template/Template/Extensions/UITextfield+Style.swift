//
//  UITextfield+Style.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func styleBorder() {
    
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func validCharacters() -> Bool {
        let invalidCharacters = "<>?/'|&~`()^{}[].,$:"
        for char in invalidCharacters {
            if (text?.contains(char))! {
                return false
            }
        }
        return true
    }
}
