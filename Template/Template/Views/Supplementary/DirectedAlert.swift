//
//  DirectedAlert.swift
//  Template
//
//  Created by Preston Perriott on 1/8/19.
//  Copyright © 2019 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit

public enum Option {
    case arrowSize(CGSize)
    case showTime(TimeInterval)
    case dismissTime(TimeInterval)
    case cornerRadius(CGFloat)
    case sideEdge(CGFloat)
    
    case overlayColor(UIColor)
    case overlayBlur(UIBlurEffect.Style)
    case type(AlertType)
    case direction(AlertDirection)
    case color(UIColor)
    case dismissOnTap(Bool)
    case showOverlay(Bool)
}

/// Or we could just supply the contentview ourselves
///determines what the content of our Alert is going to be
public enum AlertType: Int {
    case alert
    case selection
    case slider
    case input
}

public enum AlertDirection: Int {
    case auto
    case up
    case down
}

open class DirectedAlert: UIView {
    
    open var arrowSize: CGSize = CGSize(width: 16.0, height: 10.0)
    open var showTime: TimeInterval = 0.5
    open var dismissTime: TimeInterval  = 0.25
    open var cornerRadius: CGFloat = 8.0
    open var sideEdge: CGFloat = 20.0
    open var overlayColor: UIColor = UIColor(white: 0.0, alpha: 0.25) //black
    open var overlayBlur: UIBlurEffect?
    open var alertType: AlertType = .alert
    open var direction: AlertDirection = .down
    open var color: UIColor = UIColor.white
    open var dismissOnTap: Bool = true
    open var showOverlay: Bool = true

    open var slider: sliderRenderer!
    
    // custom closure
    open var willShowHandler: (() -> ())?
    open var willDismissHandler: (() -> ())?
    open var didShowHandler: (() -> ())?
    open var didDismissHandler: (() -> ())?
    
    public fileprivate(set) var overLay: UIControl = UIControl()
    
    fileprivate var containerView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var contentViewFrame: CGRect!
    fileprivate var arrowShowPoint: CGPoint!
    
    //initializers
    public init(){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.accessibilityViewIsModal = true
    }
    public init(showHandler: (() -> ())?, dismissHandler: (() -> ())?) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
        self.accessibilityViewIsModal = true
    }
    public init(options: [Option]?, showHandler: (() -> ())? = nil, dismissHandler: (() -> ())? = nil) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.setOptions(options)
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
        self.accessibilityViewIsModal = true
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
    /// Grabs last window sent makeKeyAndVisible
    /// to then pass it as the insideview of the next show func
    ///
    /// - Parameters:
    ///   - contentView: Content we want to show
    ///   - fromView: alert drops down from this object
    open func show(_ contentView: UIView, fromView: UIView) {
        guard let parentView = UIApplication.shared.keyWindow else {
            return
        }
        self.show(contentView, fromView: fromView, insideView: parentView)
    }
    
    
    /// Checks againt the popup Direction then uses fromView,
    /// to grab exact point of popup, to then pass to final show func
    ///
    /// - Parameters:
    ///   - contentView: Content we want to show
    ///   - fromView: object alert drops down from
    ///   - insideView: parent view
    open func show(_ contentView: UIView, fromView: UIView, insideView: UIView) {
        
        let dropPoint: CGPoint
        
        if self.direction == .auto {
            if let point = fromView.superview?.convert(fromView.frame.origin, to: nil),
                point.y + fromView.frame.height + self.arrowSize.height + contentView.frame.height > insideView.frame.height {
                self.direction = .up
            } else {
                self.direction = .down
            }
        }
        
        switch self.direction {
        case .up:
            dropPoint = insideView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y
            ), from: fromView.superview)
        case .down, .auto:
            dropPoint = insideView.convert(
                CGPoint(
                    x: fromView.frame.origin.x + (fromView.frame.size.width / 2),
                    y: fromView.frame.origin.y + fromView.frame.size.height
            ), from: fromView.superview)
        }
        
        show(contentView, point: dropPoint, insideView: insideView)
    }
    
    open func show(_ contentView: UIView, point: CGPoint) {
        
        guard let parentView = UIApplication.shared.keyWindow else {
            return
        }
        self.show(contentView, point: point, insideView: parentView)
    }
    
    
    /// Determines state of background overlay,
    /// Sets remaining properties of class, calls final show() method
    ///
    /// - Parameters:
    ///   - contentView: <#contentView description#>
    ///   - point: <#point description#>
    ///   - insideView: <#insideView description#>
    open func show(_ contentView: UIView, point: CGPoint, insideView: UIView) {
        
        if self.dismissOnTap || self.showOverlay {
            self.overLay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.overLay.frame = insideView.bounds
            insideView.addSubview(self.overLay)
            
            if showOverlay {
                if let overlayBlur = self.overlayBlur {
                    let effectView = UIVisualEffectView(effect: overlayBlur)
                    effectView.frame = self.overLay.bounds
                    effectView.isUserInteractionEnabled = false
                    self.overLay.addSubview(effectView)
                } else {
                    self.overLay.alpha = 0
                }
            }
            
            if self.dismissOnTap {
                self.overLay.addTarget(self, action: #selector(DirectedAlert.dismiss), for: .touchUpInside)
            }
        }
        
        switch self.alertType {
        case .alert:
            
            break
        case .input:
            break
        case .selection:
            break
        case .slider:
            ///TODO: How do we then solve delegation for the slider to the controller
            let slider = UISlider()
            slider.frame = contentView.frame
            slider.thumbTintColor = .blue
            slider.isContinuous = true
            contentView.addSubview(slider)
            
            let slide = sliderRenderer(frame: contentView.frame)
            slide.isContinuous = true
            break
        }
        
        self.containerView = insideView
        self.contentView = contentView
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.layer.masksToBounds = true
        self.arrowShowPoint = point
        self.show()
    }
    
    open override func accessibilityPerformEscape() -> Bool {
        self.dismiss()
        return true
    }
    
    @objc open func dismiss() {
        if self.superview != nil {
            self.willDismissHandler?()
            UIView.animate(withDuration: self.showTime, delay: 0,
                           options: UIView.AnimationOptions(),
                           animations: {
                            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                            self.overLay.alpha = 0
            }){ _ in
                self.contentView.removeFromSuperview()
                self.overLay.removeFromSuperview()
                self.removeFromSuperview()
                self.transform = CGAffineTransform.identity
                self.didDismissHandler?()
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let arrow = UIBezierPath()
        let color = self.color
        let arrowPoint = self.containerView.convert(self.arrowShowPoint, to: self)
        switch self.direction {
        case .up:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: self.bounds.height))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x - self.arrowSize.width * 0.5,
                    y: self.isCornerLeftArrow ? self.arrowSize.height : self.bounds.height - self.arrowSize.height
                )
            )
            
            arrow.addLine(to: CGPoint(x: self.cornerRadius, y: self.bounds.height - self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.bounds.height - self.arrowSize.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(90),
                endAngle: self.radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(180),
                endAngle: self.radians(270),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width - self.cornerRadius, y: 0))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(270),
                endAngle: self.radians(0),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - self.arrowSize.height - self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.bounds.height - self.arrowSize.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(0),
                endAngle: self.radians(90),
                clockwise: true)
            
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + self.arrowSize.width * 0.5,
                    y: self.isCornerRightArrow ? self.arrowSize.height : self.bounds.height - self.arrowSize.height
                )
            )
            
        case .down, .auto:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLine(
                to: CGPoint(
                    x: arrowPoint.x + self.arrowSize.width * 0.5,
                    y: self.isCornerRightArrow ? self.arrowSize.height + self.bounds.height : self.arrowSize.height
                )
            )
            
            arrow.addLine(to: CGPoint(x: self.bounds.width - self.cornerRadius, y: self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.arrowSize.height + self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(270.0),
                endAngle: self.radians(0),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.bounds.width - self.cornerRadius,
                    y: self.bounds.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(0),
                endAngle: self.radians(90),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.bounds.height))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.bounds.height - self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(90),
                endAngle: self.radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.arrowSize.height + self.cornerRadius))
            arrow.addArc(
                withCenter: CGPoint(
                    x: self.cornerRadius,
                    y: self.arrowSize.height + self.cornerRadius
                ),
                radius: self.cornerRadius,
                startAngle: self.radians(180),
                endAngle: self.radians(270),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(
                x: arrowPoint.x - self.arrowSize.width * 0.5,
                y: self.isCornerLeftArrow ? self.arrowSize.height + self.bounds.height : self.arrowSize.height))
        }
        
        color.setFill()
        arrow.fill()
    }
    
}

private extension DirectedAlert {
    
    func setOptions(_ options: [Option]?) {
        if let options = options {
            for option in options {
                switch option {
                case let .arrowSize(value):
                    self.arrowSize = value
                case let .showTime(value):
                    self.showTime = value
                case let .dismissTime(value):
                    self.dismissTime = value
                case let .cornerRadius(value):
                    self.cornerRadius = value
                case let .sideEdge(value):
                    self.sideEdge = value
                case let .overlayColor(value):
                    self.overlayColor = value
                case let .overlayBlur(style):
                    self.overlayBlur = UIBlurEffect(style: style)
                case let .type(value):
                    self.alertType = value
                case let .direction(value):
                    self .direction = value
                case let .color(value):
                    self.color = value
                case let .dismissOnTap(value):
                    self.dismissOnTap = value
                case let .showOverlay(value):
                    self.showOverlay = value
                }
            }
        }
    }
    
    func create() {
        var frame = self.contentView.frame
        frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5
        
        var sideEdge: CGFloat = 0.0
        if frame.size.width < self.containerView.frame.size.width {
            sideEdge = self.sideEdge
        }
        
        let outerSideEdge = frame.maxX - self.containerView.bounds.size.width
        if outerSideEdge > 0 {
            frame.origin.x -= (outerSideEdge + sideEdge)
        } else {
            if frame.minX < 0 {
                frame.origin.x += abs(frame.minX) + sideEdge
            }
        }
        self.frame = frame
        
        let arrowPoint = self.containerView.convert(self.arrowShowPoint, to: self)
        var anchorPoint: CGPoint
        switch self.direction {
        case .up:
            frame.origin.y = self.arrowShowPoint.y - frame.height - self.arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
        case .down, .auto:
            frame.origin.y = self.arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
        }
        
        if self.arrowSize == .zero {
            anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        
        let lastAnchor = self.layer.anchorPoint
        self.layer.anchorPoint = anchorPoint
        let x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width
        let y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
        self.layer.position = CGPoint(x: x, y: y)
        
        frame.size.height += self.arrowSize.height
        self.frame = frame
    }
    
    func show() {
        self.setNeedsDisplay()
        switch self.direction {
        case .up:
            self.contentView.frame.origin.y = 0.0
        case .down, .auto:
            self.contentView.frame.origin.y = self.arrowSize.height
        }
        self.addSubview(self.contentView)
        self.containerView.addSubview(self)
        
        self.create()
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.willShowHandler?()
        UIView.animate(
            withDuration: self.showTime,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 3,
            options: UIView.AnimationOptions(),
            animations: {
                self.transform = CGAffineTransform.identity
        }){ _ in
            self.didShowHandler?()
        }
        UIView.animate(
            withDuration: self.showTime / 3,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.overLay.alpha = 1
        }, completion: nil)
    }
    
    var isCornerLeftArrow: Bool {
        return self.arrowShowPoint.x == self.frame.origin.x
    }
    
    var isCornerRightArrow: Bool {
        return self.arrowShowPoint.x == self.frame.origin.x + self.bounds.width
    }
    
    func radians(_ degrees: CGFloat) -> CGFloat {
        return CGFloat.pi * degrees / 180
    }
}



@objc public protocol DirectedAlertSliderDelegate: class {
    
    /// Tells us when the slider started sliding and its value
    ///
    /// - Parameter alertSlider: the dropped down slider
    /// - Returns: slider value
    func sliderDidSlideToValue(_ alertSlider: sliderRenderer) -> Int
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - alertSlider: <#alertSlider description#>
    ///   - color: <#color description#>
    func sliderColor(_ alertSlider: sliderRenderer, color: UIColor)
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - alertSlider: <#alertSlider description#>
    ///   - position: <#position description#>
    func updateSliderToPosition(_ alertSlider: sliderRenderer, position: Int)
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - alertSlider: <#alertSlider description#>
    ///   - close: <#close description#>
    func shouldCloseSlider(_ alertSlider: sliderRenderer, close: Bool)
}

public class sliderRenderer: UISlider {
    
    weak open var delegate: AnyObject? {
        didSet {
            if let d = delegate {
                if let d = (d as? DirectedAlertSliderDelegate) {
                    delegate = d
                } else {
                    assertionFailure("Must Implement Delegate")
                }
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.addTarget(self, action: "sliderValueChanged:", for: .valueChanged)
    }
    
//    func updatedValue() -> String {
//
//    }
}

