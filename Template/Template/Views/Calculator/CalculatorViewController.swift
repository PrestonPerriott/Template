//
//  CalculatorViewController.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var unitTF1: UITextField!
    @IBOutlet weak var unitTF2: UITextField!
    @IBOutlet weak var unitTF3: UITextField!
    
    @IBOutlet weak var overlapHeaderView: UIView!
    @IBOutlet weak var calculatedStaticVariablesView: UIView!
    @IBOutlet weak var calculationView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.applyGradient(with: [UIColor.init(red: 21/255, green: 21/255, blue: 23/255, alpha: 0.75).cgColor, UIColor.init(red: 41/255, green: 35/255, blue: 46/255, alpha: 0.75).cgColor, UIColor.init(red: 57/255, green: 48/255, blue: 66/255, alpha: 0.75).cgColor])
      
        
        let viewArray: [UIView] = [overlapHeaderView, calculatedStaticVariablesView, calculationView, calculatorView]
        for view in viewArray {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowRadius = 6
        }
    }
}
