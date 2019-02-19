//
//  CalculatorHeaderCellController.swift
//  Template
//
//  Created by Preston Perriott on 12/4/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

protocol CalculatorHeaderCellDelegate: class {
    
}

class CalculatorHeaderCellController: NSObject {
    
    weak var cellDelegate: CalculatorHeaderCellDelegate?
}

extension CalculatorHeaderCellController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ///Fire off notification for other listeners 
    }
}

