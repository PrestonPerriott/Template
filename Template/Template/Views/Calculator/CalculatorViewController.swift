//
//  CalculatorViewController.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit
import FSPagerView
import SJFluidSegmentedControl

enum FieldID: Int {
    case spice = 0
    case oil = 1
    case weight = 2
}

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var overlapHeaderView: UIView!
    @IBOutlet weak var carouselView: FSPagerView!
    @IBOutlet weak var carouselPageControl: FSPageControl!
    
    
    @IBOutlet weak var segmentedControl: SJFluidSegmentedControl!
    
    
    @IBOutlet weak var calculatedStaticVariablesView: UIView!
    /// 3 textviews for Herb, Oil and Weight
    @IBOutlet var userInputTextViews: [UITextField]!
    
    @IBOutlet weak var calculationView: UIView!
    /// Label for overall calculation
    
    let controller = CalculationController()
    
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet var calculatorButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet var actionButtons: [UIButton]!
    var allButtons = [UIButton]()
    
    var currViewableTextField: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextFieldWithValue(_:)), name: .calculatorButtonPress, object: nil)
        
        self.view.applyGradient(with: [UIColor.init(red: 21/255, green: 21/255, blue: 23/255, alpha: 1).cgColor, UIColor.init(red: 41/255, green: 35/255, blue: 46/255, alpha: 1).cgColor, UIColor.init(red: 57/255, green: 48/255, blue: 66/255, alpha: 1).cgColor])
      
        let viewArray: [UIView] = [overlapHeaderView, calculatedStaticVariablesView, calculationView, calculatorView]
        for view in viewArray {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowRadius = 6
            view.layer.cornerRadius = 1
        }
        
        allButtons.append(contentsOf: calculatorButtons)
        allButtons.append(contentsOf: operationButtons)
        allButtons.append(contentsOf: actionButtons)
        
        for button in allButtons {
            button.backgroundColor = UIColor.black
        }
    
        carouselView.dataSource = controller
        carouselView.delegate = controller
        carouselView.isInfinite = true
        carouselView.transformer = FSPagerViewTransformer(type: .crossFading)
        carouselPageControl.numberOfPages = 3
        carouselPageControl.setFillColor(UIColor.black, for: .normal)
        carouselPageControl.interitemSpacing = 10
        
        controller.createHeaderCells()
        controller.registerHeaderCell(fsPagerView: carouselView)
        controller.delegate = self
        
        segmentedControl.dataSource = controller
        segmentedControl.delegate = controller
        
    }

    @IBAction func pressedCalcViewButton(sender: UIButton) {
        if let title = sender.title(for: .normal) {
            NotificationCenter.default.post(name: .calculatorButtonPress, object: self, userInfo: ["Button": title])
        } else {
            ///No title
        }
    }
    
    @objc private func updateTextFieldWithValue(_ notification: NSNotification) {
        if let pressed = notification.userInfo?["Button"] as? String {
            ///find the active textfield and insert the latest value there.
            print("The button that was passed is : \(pressed)")
            if (userInputTextViews[carouselView.currentIndex].text?.hasNumbers())! {
                userInputTextViews[carouselView.currentIndex].text?.append(pressed)
            } else if !(userInputTextViews[carouselView.currentIndex].text?.hasNumbers())! {
                userInputTextViews[carouselView.currentIndex].text? = ""
                userInputTextViews[carouselView.currentIndex].text?.append(pressed)
            }
            
        } else {
            /// If that button key value pair isn't there
        }
    }
    
}

extension CalculatorViewController: CalculationControllerDelegate {
    
    func willShowSegmentView(segmentView: UIView) {
        self.view.addSubview(segmentView)
    }
    
    func didMoveSegment(fieldID: Int) {
        carouselView.scrollToItem(at: fieldID, animated: true)
        userInputTextViews[fieldID].becomeFirstResponder()
        print("calling did move segment")
    }
    
    func didMoveHeader(fieldID: Int) {
        segmentedControl.setCurrentSegmentIndex(fieldID, animated: true)
        userInputTextViews[fieldID].becomeFirstResponder()
        print("Calling didMoveHeader")
    }
    
    ///should be replaced by delegation in the headercell ie. isUpdatingHeaderText
    func didTouchHeaderCalculation(fieldID: Int) { ///Should eb alterting large calcText
        for tf in userInputTextViews {
            tf.textColor = UIColor.white
        }
        if let id = FieldID(rawValue: fieldID) {
            switch id {
            case .spice:
                print("target spice textfield")
                userInputTextViews[fieldID].inputView = calculatorView
            case .oil:
                print("target the oil field")
                userInputTextViews[fieldID].inputView = calculatorView
            case .weight:
                print("target weight field")
                userInputTextViews[fieldID].inputView = calculatorView
            }
        }
    }
}
