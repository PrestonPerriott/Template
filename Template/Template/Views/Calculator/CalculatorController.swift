//
//  CalculatorController.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import FSPagerView
import SJFluidSegmentedControl

/// CalculatorViewController Adheres to this protocol
/// Used to select the non header user values that need input
protocol CalculationControllerDelegate: class {
    func didTouchHeaderCalculation(fieldID: Int)
    func didMoveHeader(fieldID: Int)
    func didMoveSegment(fieldID: Int)
    
    func willShowSegmentView(segmentView: UIView)
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
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        delegate?.didMoveHeader(fieldID: targetIndex)
    }
}

extension CalculationController: SJFluidSegmentedControlDelegate, SJFluidSegmentedControlDataSource {
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return headerCells.count
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          titleForSegmentAtIndex index: Int) -> String? {
        return headerCells[index].title?.uppercased()
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        switch index {
        case 0:
            return [UIColor(red: 0 / 255.0, green: 129 / 255.0, blue: 0 / 255.0, alpha: 1.0),
                    UIColor(red: 97 / 255.0, green: 199 / 255.0, blue: 234 / 255.0, alpha: 1.0)]
        case 1:
            return [UIColor(red: 227 / 255.0, green: 206 / 255.0, blue: 160 / 255.0, alpha: 1.0),
                    UIColor(red: 225 / 255.0, green: 195 / 255.0, blue: 128 / 255.0, alpha: 1.0)]
        case 2:
            return [UIColor(red: 0 / 255.0, green: 129 / 255.0, blue: 0 / 255.0, alpha: 1.0),
                    UIColor(red: 9 / 255.0, green: 82 / 255.0, blue: 107 / 255.0, alpha: 1.0)]
        default:
            break
        }
        return [.clear]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        switch bounce {
        case .left:
            return [UIColor(red: 51 / 255.0, green: 149 / 255.0, blue: 182 / 255.0, alpha: 1.0)]
        case .right:
            return [UIColor(red: 9 / 255.0, green: 82 / 255.0, blue: 107 / 255.0, alpha: 1.0)]
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didScrollWithXOffset offset: CGFloat) {
        
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        ///Add code to change header cell here
        delegate?.didMoveSegment(fieldID: toIndex)

        let view = UIView()
        let options: [Option] = [.color(.black), .overlayColor(.red)]
        if toIndex == 0 {
            
            let viewHeight = segmentedControl.frame.height * 2
            view.frame = CGRect.init(x: 0, y: 0, width: segmentedControl.frame.width * 0.8, height:viewHeight * 0.5)
            let alert = DirectedAlert(options: options, showHandler: nil, dismissHandler: nil)
            alert.show(view, point: CGPoint(x: segmentedControl.frame.minX, y: segmentedControl.frame.maxY))
            ///Call delegate method that sends view to parent viewcontroller
            //delegate?.willShowSegmentView(segmentView: view)
            
        } else if toIndex == 1 {
            
            let options2: [Option] = [.color(.black), .type(.slider)]
            ///Maybe 3D tocuh for oil/butter option??
            let viewHeight = segmentedControl.frame.height * 2
            view.frame = CGRect.init(x: 0, y: 0, width: segmentedControl.frame.width / 2, height:viewHeight * 0.8)
            let alert = DirectedAlert(options: options2, showHandler: nil, dismissHandler: nil)
            alert.show(view, point: CGPoint(x: segmentedControl.frame.midX, y: segmentedControl.frame.maxY))
           // delegate?.willShowSegmentView(segmentView: view)
            
        }
    }
}

extension CalculationController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didTouchHeaderCalculation(fieldID: textField.tag)
        print("Textfield editing")
    }
}

extension Notification.Name {
    static let calculatorButtonPress = Notification.Name("calcButtonPress")
}
