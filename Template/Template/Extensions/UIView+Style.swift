//
//  UIView+Style.swift
//  Template
//
//  Created by Preston Perriott on 11/17/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

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
    
    func applyGradient(with colorArray: [CGColor]) {
        //clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 0.4, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
