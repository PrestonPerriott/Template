//
//  CalculatorController.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import FSPagerView

/// CalculatorViewController Adheres to this protocol
/// Used to select the non header user values that need input
protocol CalculationControllerDelegate: class {
    func didTouchHeaderCalculation(fieldID: Int)
}

class CalculationController: NSObject {
    
    weak var delegate: CalculationControllerDelegate?
    var headerCells = [UserCalcInput]()
    

    public func registerHeaderCell(fsPagerView: FSPagerView) {
        fsPagerView.register(UINib(nibName: "CalculatorHeaderCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CalculatorHeaderCell")
    }
    
    func createHeaderCells() {
        headerCells.append(UserCalcInput.init(type: .herb))
        headerCells.append(UserCalcInput.init(type: .oil))
        headerCells.append(UserCalcInput.init(type: .weight))
    }
    
    func listenForCalculatorButtonPress(sender: UIButton) {
        ///Delegate method fired when any button on the calculator is pressed
        ///Which then fires off a notification for mutlipe things to listen to
        ///Takes button then fires off notification on which number/value
    }
    
}

extension CalculationController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return headerCells.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CalculatorHeaderCell", at: index) as! CalculatorHeaderCell
        cell.backgroundImageView.image = headerCells[index].image
        cell.backgroundImageView.clipsToBounds = true
        cell.backgroundImageView.contentMode = .scaleAspectFill
        cell.calculationTextField.text = "\(headerCells[index].calculation ?? 0)"
        cell.calculationTextField.delegate = self
        cell.calculationTextField.tag = index
        cell.infoTextLabel.text = headerCells[index].infoText
        cell.metricLabel.text = headerCells[index].metric
        cell.infoTextTitleLabel.text = headerCells[index].title
        cell.type = headerCells[index].type
        return cell
    }
    
}

extension CalculationController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didTouchHeaderCalculation(fieldID: textField.tag)
    }
}

extension Notification.Name {
    static let calculatorButtonPress = Notification.Name("calcButtonPress")
}
