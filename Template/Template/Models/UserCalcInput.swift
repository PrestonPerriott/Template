//
//  UserCalcInput.swift
//  Template
//
//  Created by Preston Perriott on 12/2/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

enum type {
    case oil
    case herb
    case weight
}

struct UserCalcInput {

    let title: String?
    let type: type?
    let image: UIImage?
    let metric: String?
    let infoText: String?
    let calculation: Float?
    
    init(type: type) {
        switch type {
        case .oil:
            self.title = "Oil"
            self.calculation = 0.0
            self.infoText = "The oil measurement is an important measurement because it allows us to......"
            self.type = type
            self.image = UIImage(named: "oil")
            self.metric = "Tbsp"
        case .herb:
            self.title = "Herb"
            self.calculation = 0.0
            self.infoText = "The Herb measurement is an important measurement because it allows us to......"
            self.type = type
            self.image = UIImage(named: "herbalPercent")
            self.metric = "Percent"
        case .weight:
            self.title = "Weight"
            self.calculation = 0.0
            self.infoText = "The weight measurement is an important measurement because it allows us to......"
            self.type = type
            self.image = UIImage(named: "weight")
            self.metric = "Grams"
        }
    }
}
