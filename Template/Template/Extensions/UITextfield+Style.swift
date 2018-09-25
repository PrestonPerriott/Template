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
    
    func textFieldWillShift(_ textfield: UITextField, distance: Int, up: Bool) {
        let duration = 0.25
        let movement: CGFloat = CGFloat(up ? distance : -distance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        frame = frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
