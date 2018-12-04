//
//  CalculatorViewController.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit
import FSPagerView

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var overlapHeaderView: UIView!
    @IBOutlet weak var calculatedStaticVariablesView: UIView!
    @IBOutlet weak var calculationView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    
    @IBOutlet weak var carouselView: FSPagerView! {
        didSet {
            let nib  = UINib(nibName: "CalculatorHeaderCell", bundle: Bundle.main)
            self.carouselView.register(nib, forCellWithReuseIdentifier: "CalculatorHeaderCell")
        }
    }
    @IBOutlet weak var carouselPageControl: FSPageControl!
    
    let controller = CalculationController()
    
    @IBOutlet var calculatorButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.applyGradient(with: [UIColor.init(red: 21/255, green: 21/255, blue: 23/255, alpha: 1).cgColor, UIColor.init(red: 41/255, green: 35/255, blue: 46/255, alpha: 1).cgColor, UIColor.init(red: 57/255, green: 48/255, blue: 66/255, alpha: 1).cgColor])
      
        let viewArray: [UIView] = [overlapHeaderView, calculatedStaticVariablesView, calculationView, calculatorView]
        for view in viewArray {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowRadius = 6
            view.layer.cornerRadius = 1
        }
    
        carouselView.dataSource = controller
        carouselView.delegate = controller
        carouselView.isInfinite = true
        carouselView.transformer = FSPagerViewTransformer(type: .crossFading)
        carouselPageControl.numberOfPages = 3
        carouselPageControl.interitemSpacing = 10
        
        controller.createHeaderCells()
        controller.registerHeaderCell(fsPagerView: carouselView)
        
        let subviews = calculatorView.subviews
        for view in subviews {
            if let stackView = view as? UIStackView {
                for button in stackView.subviews {
                    if let btn = button as? UIButton {
                        //btn.layer.borderColor = UIColor.white.cgColor
                        btn.backgroundColor = UIColor.black
                       // btn.layer.borderWidth = 0.5
                    }
                }
            } else {
                print("Objects are not buttons")
            }
        }
    }
    
    
}
