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
        
        layer.cornerRadius = 3
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.white.cgColor
    }
}
