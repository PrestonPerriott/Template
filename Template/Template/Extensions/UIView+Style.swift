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
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension UILabel {
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
    
}
