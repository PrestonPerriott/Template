//
//  CalculatorHeaderCell.swift
//  Template
//
//  Created by Preston Perriott on 12/2/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit
import FSPagerView

class CalculatorHeaderCell: FSPagerViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var calculationTextField: UITextField!
    @IBOutlet weak var metricLabel: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var infoTextView: UIView!
    @IBOutlet weak var infoTextTitleLabel: UILabel!
    @IBOutlet weak var infoTextCloseButton: UIButton!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    var type: type!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoTextLabel.layer.cornerRadius = 5
        infoTextLabel.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        print("tapped info button")
        UIView.transition(with: self, duration: 0.75, options: .curveEaseInOut, animations: {
            self.infoTextView.alpha = 0.65
            self.calculationTextField.alpha = 0.0
            self.infoButton.alpha = 0.0
            }, completion: nil)
    }
    
    @IBAction func closeInfoTextViewPressed(_ sender: UIButton) {
        UIView.transition(with: self, duration: 0.75, options: .curveEaseInOut, animations: {
            self.infoTextView.alpha = 0.0
            self.calculationTextField.alpha = 1.0
            self.infoButton.alpha = 1.0
        }, completion: nil)
    }
    
    
}
