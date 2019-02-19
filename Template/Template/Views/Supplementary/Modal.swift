//
//  Modal.swift
//  Template
//
//  Created by Preston Perriott on 2/14/19.
//  Copyright © 2019 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

protocol ModalDelegate {
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var parentView: UIView {get}
    var modalView: UIView {get set}
}

public enum ModalOption {
    case image(UIImage)
    case modalColor(UIColor)
    case modalTextColor(UIColor)
    case overlay(Bool)
    case overlayColor(UIColor)
}

class Modal: UIView, ModalDelegate {

    var parentView = UIView()
    var modalView = UIView()
    var image: UIImage?
    var modalColor: UIColor = UIColor.white
    var modalTextColor: UIColor = UIColor.black
    var overlay: Bool = true
    var overlayColor: UIColor = UIColor.black

    convenience init(title: String, message:String, options: [ModalOption]?) {
        self.init(frame: UIScreen.main.bounds)
        self.create(title: title, message: message, options: options)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func create(title: String, message: String, options: [ModalOption]?) {
        self.setOptions(options)
        modalView.clipsToBounds = true

        parentView.frame = frame
        parentView.backgroundColor = UIColor.black
        parentView.alpha = 0.6
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(parentView)

        let dialogViewWidth = frame.width-64

        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30))
        titleLabel.text = title
        titleLabel.textColor = modalTextColor
        titleLabel.textAlignment = .center
        modalView.addSubview(titleLabel)

        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        modalView.addSubview(separatorLineView)

        let messageLabel = UILabel(frame: CGRect(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y + 8, width: dialogViewWidth-16, height: 50))
        messageLabel.text = message
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.65;
        messageLabel.numberOfLines = 0
        messageLabel.textColor = modalTextColor
        messageLabel.textAlignment = .center
        modalView.addSubview(messageLabel)

        if let image = image {
            let imageView = UIImageView()
            imageView.frame.origin = CGPoint(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y + 8)
            imageView.frame.size = CGSize(width: dialogViewWidth - 16 , height: dialogViewWidth - 16)
            imageView.image = image
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
            modalView.addSubview(imageView)
            let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + imageView.frame.height + 8

            modalView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)

        } else {
            let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + 8 + messageLabel.frame.height + 8
            modalView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        }

        modalView.frame.origin = CGPoint(x: 32, y: frame.height)
        modalView.backgroundColor = modalColor
        modalView.layer.cornerRadius = 6
        addSubview(modalView)
    }

    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }

    func show(animated: Bool) {
        self.parentView.alpha = 0
        self.modalView.center = CGPoint(x: self.center.x, y: self.frame.height + self.modalView.frame.height/2)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.parentView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.modalView.center  = self.center
            }, completion: { (completed) in

            })
        }else{
            self.parentView.alpha = 0.66
            self.modalView.center  = self.center
        }
    }

    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.parentView.alpha = 0
            }, completion: { (completed) in

            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.modalView.center = CGPoint(x: self.center.x, y: self.frame.height + self.modalView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
    }
}

extension Modal {
    
    func setOptions(_ options: [ModalOption]?) {

        if let options = options {
            for option in options {
                switch option {
                case let .image(value):
                    self.image = value
                case let .modalColor(value):
                    self.modalColor = value
                case let .modalTextColor(value):
                    self.modalTextColor = value
                case let .overlay(value):
                    self.overlay = value
                case let .overlayColor(value):
                    self.overlayColor = value
                }
            }
        }
    }
}
