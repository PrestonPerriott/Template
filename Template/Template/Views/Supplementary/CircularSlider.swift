//
//  CircularSlider.swift
//  Template
//
//  Created by Preston Perriott on 11/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

///Were leaving this as one file so that anyone who would like to use this, just needs the one file
import UIKit
///Class essentially made up of 2 CALayers
///One layer manages the track
///Second layer manages the pointer itself

///Cheap to rotate layers using Core Animation
///Expensive to animate/override drawRect in CoreGraphics == sluggish animation

class CircularSlider: UIControl {
    private let renderer = CircularSliderRenderer()
    
    ///Basic operating params
    var minValue: Float = 0
    var maxValue: Float = 1
    var isContinuous = true ///true=continual call back w/ change
                            ///false=call back once, when user is done
    
    ///Allowing external access to variables as proxies
    var lineWidth: CGFloat {
        get {return renderer.lineWidth}
        set {renderer.lineWidth = newValue}
    }
    
    var startAngle: CGFloat {
        get {return renderer.startAngle}
        set {renderer.startAngle = newValue}
    }
    
    var endAngle: CGFloat {
        get {return renderer.endAngle}
        set {renderer.endAngle = newValue}
    }
    
    var pointerLength: CGFloat {
        get {return renderer.pointerLength}
        set {renderer.pointerLength = newValue}
    }
    
    private (set) var value: Float = 0
    ///Set control val programatically, we make values setter private
    ///We do this because it can/should only be set btwn 1-0
    func setValue(_ newVal: Float, animated:Bool = false) {
        value = min(maxValue, max(minValue, newVal))
        
        let angleRange = endAngle - startAngle
        let valRange = maxValue - minValue
        let angleVal = CGFloat(value - minValue) / CGFloat(valRange) * angleRange + startAngle
        renderer.setPointerAngle(angleVal, animated: animated)
        ///Func maps angle for given val and maps out min & max values ranges to min and max angle ranges of the circle and sets pointer angle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    ///sets renderers size, then adds the two layers
    private func commonInit() {
        renderer.updateBounds(bounds)
        renderer.color = tintColor
        renderer.setPointerAngle(renderer.startAngle)
        
        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)
    }
}

///Seperate out appearance from actual control
private class CircularSliderRenderer {
    
    private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11/8
    ///CAShapeLayer is sub of CALayer, that draws a bezier path using,
    ///anti-aliasing, makes it effecient in drawing shapes
    let trackLayer = CAShapeLayer()
    let pointerLayer = CAShapeLayer()
    
    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.fillColor = UIColor.clear.cgColor
    }
    
    var color: UIColor = UIColor.purple {
        didSet {
            trackLayer.strokeColor = color.cgColor
            pointerLayer.strokeColor = color.cgColor
        }
    }
    
    var lineWidth: CGFloat = 10 {
        didSet {
            trackLayer.lineWidth = lineWidth
            pointerLayer.lineWidth = lineWidth
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }
    
    var startAngle: CGFloat = CGFloat(-Double.pi) * 11/8 {
        didSet {
            updateTrackLayerPath()
        }
    }
    
    var endAngle: CGFloat = CGFloat(Double.pi) * 3/8 {
        didSet {
            updateTrackLayerPath()
        }
    }
    
    var pointerLength: CGFloat = 10 {
        didSet {
            updateTrackLayerPath()
            updateTrackLayerPath()
        }
    }
    
    func setPointerAngle(_ newAngle: CGFloat, animated: Bool = false) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        ///this transform rotates layer around z axis by angle given
        pointerLayer.transform = CATransform3DMakeRotation(newAngle, 0, 0, 1)
        
        if animated {
            let midAngle = (max(newAngle, pointerAngle) - min(newAngle, pointerAngle)) / 2 + min(newAngle, pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [pointerAngle, midAngle, newAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
            pointerLayer.add(animation, forKey: nil)
        }
        
        CATransaction.commit()
        pointerAngle = newAngle
    }
    
    ///Takes a bounds rectangle, resizes layers to match,
    ///then pos the layers in center of bounding retangle
    ///In changing a prop that affects the path, we must call this manually
    func updateBounds(_ bounds: CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateTrackLayerPath()
        
        pointerLayer.bounds = trackLayer.bounds
        pointerLayer.position = trackLayer.position
        updatePointerLayerPath()
    }
    ///Calling either below funcs, redraws the shapeLayers
    
    ///Creates arc between startAngle and endAngle
    ///Pos the pointer in the middle of the trackLayer
    private func updateTrackLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offSet = max(pointerLength, lineWidth / 2)
        let radius = min(bounds.width, bounds.height) / 2 - offSet
        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = ring.cgPath
    }
    
    ///Creates path for pointer at pos where angle is 0
    private func updatePointerLayerPath() {
        let bounds = trackLayer.bounds
        let pointer = UIBezierPath()
        
        pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
        pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        pointerLayer.path = pointer.cgPath
    }
    
}
///Will behave like a pan gesture recog
///Tracking a single finger dragging across screen
private class CircularRotationRecognizer: UIPanGestureRecognizer {
    ///Touch angle represents the touch angle line which joins the current touch point,
    /// to the center of the view, to which the gesture recog is attached
    private (set) var touchAngle: CGFloat = 0
    
}
