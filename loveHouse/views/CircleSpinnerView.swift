//
//  CircleSpinnerView.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/8.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

let kSARRingStrokeAnimationKey = "circleSpinnerStroke"
let kSARRingRotationAnimationKey = "circleSpinnerRotation"
let kSARRingStrokeAnimationDuration = 1.5

class CircleSpinnerView: UIView {
    let progressLayer = CAShapeLayer()  //圆形的进度layer
    var timingFunction: CAMediaTimingFunction!  //动画的计时函数
    var isAnimating = false //是否动画
    let tipLayer = CATextLayer()    //文字图层

    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override func layoutSubviews() {
        self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        tipLayer.frame = CGRectMake(0, progressLayer.frame.height , CGRectGetWidth(self.bounds), 21)
        self.updateProgressLayerPath()
    }
    

    func setup(){
        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        setupProgressLayer()
    }
    
    func setupProgressLayer() {
        progressLayer.strokeColor = UIColor.redColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.lineWidth = 2.0
        tipLayer.alignmentMode = kCAAlignmentCenter
        tipLayer.contentsScale = UIScreen.mainScreen().scale
        tipLayer.fontSize = 14
        tipLayer.string = message
        tipLayer.foregroundColor = strokeColor.CGColor
        self.layer.addSublayer(tipLayer)
        self.layer.addSublayer(progressLayer)
        self.updateProgressLayerPath()
    }
    
    func updateProgressLayerPath() {
        let center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
        let radius = min(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2*CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.CGPath
        
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
    }
    
    var lineWidth: CGFloat {
        get {
            return self.progressLayer.lineWidth
        }
        set(newValue) {
            self.progressLayer.lineWidth = newValue
            self.updateProgressLayerPath()
        }
    }
    
    var strokeColor: UIColor {
        get {
            return UIColor(CGColor: self.progressLayer.strokeColor!)
        }
        set(newValue) {
            self.progressLayer.strokeColor = newValue.CGColor
            self.tipLayer.foregroundColor = newValue.CGColor
        }
    }
    
    
    var message:String {
        get {
            return "正在加载"
        }
        set(newValue) {
            self.tipLayer.string = newValue
        }
    }
    
    //    MARK: -Animation Methods
    func startAnimating() {
        if self.isAnimating {
            return
        }
        self.tipLayer.hidden = false

        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 4
        animation.fromValue = 0
        animation.toValue = (2 * M_PI)
        animation.repeatCount = Float.infinity
        self.progressLayer.addAnimation(animation, forKey: kSARRingRotationAnimationKey)
        
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = 1
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = 1
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = self.timingFunction;
        
        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.beginTime = 1
        endHeadAnimation.duration = 0.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = 1
        endTailAnimation.duration = 0.5
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = kSARRingStrokeAnimationDuration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity;
        self.progressLayer.addAnimation(animations, forKey: kSARRingStrokeAnimationKey)
        
        
        self.isAnimating = true
        
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.progressLayer.removeAnimationForKey(kSARRingRotationAnimationKey)
        self.progressLayer.removeAnimationForKey(kSARRingStrokeAnimationKey)
        self.tipLayer.hidden = true
        self.isAnimating = false
        
    }

    
}
