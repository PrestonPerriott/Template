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


extension UIView {
    
    enum fadeDirection {
        case fadeIn
        case fadeOut
    }
    
    func fade(directon: fadeDirection) {
        switch directon {
        case .fadeIn:
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1.0
            }, completion: nil)
        case .fadeOut:
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.0
            }, completion: nil)
        }
    }
    
}
