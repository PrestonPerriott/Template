//
//  UIButton+Style.swift
//  Template
//
//  Created by Preston Perriott on 10/15/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func styleBorder() {
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = width
        border.cornerRadius = 5
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
}
