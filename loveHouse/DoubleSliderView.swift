//
//  DoubleSliderView.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/14.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

@IBDesignable

class DoubleSliderView: UIView {

    // 进度条背景
    var progressBackground:CALayer = CALayer()
    
    // 中间进度条
    var progressLine:CALayer = CALayer()
    
    //左侧圆形按钮
    var leftButton:CALayer = CALayer()
    //右侧圆形按钮
    var rightButton:CALayer = CALayer()
    
    //左侧水滴形提示图案
    var leftTip:CAShapeLayer = CAShapeLayer()
    //右侧水滴形提示图案
    var rightTip:CAShapeLayer = CAShapeLayer()
    
    //左侧水滴形提示文字layer
    var leftPinTextLayer:CATextLayer = CATextLayer()
    //右侧水滴形提示文字layer
    var rightPinTextLayer:CATextLayer = CATextLayer()
    
    //左侧随进度条移动的文字layer
    var leftTipTextLayer:CATextLayer = CATextLayer()
    //右侧随进度条移动的文字layer
    var rightTipTextLayer:CATextLayer = CATextLayer()
    
    //最大进度值
    @IBInspectable var maxProgress:CGFloat = 100
    //最小进度值
    @IBInspectable var minProgress:CGFloat = 0
    //进度间隔值
    @IBInspectable var spaceProgress:CGFloat = 20
    
    //按钮半径
    @IBInspectable var radius:CGFloat = 18
    //动画速度
    @IBInspectable var animateSpeed:Float = 8 {
        didSet {
            leftTip.speed = animateSpeed
            rightTip.speed = animateSpeed
            leftButton.speed = animateSpeed
            rightButton.speed = animateSpeed
            progressLine.speed = animateSpeed
            leftTipTextLayer.speed = animateSpeed
            rightTipTextLayer.speed = animateSpeed
        }
    }
    
    //最小值文字提示
    @IBInspectable var minTipText:String? {
        didSet {
            let minProgressString = "\(Int(leftProgress))"
            leftTipTextLayer.string = leftProgress == minProgress ? (minTipText ?? minProgressString) : minProgressString

        }
    }
    //最大值文字提示
    @IBInspectable var maxTipText:String? {
        didSet {
            let maxProgressString = "\(Int(rightProgress))"
            rightTipTextLayer.string = rightProgress == maxProgress ? (maxTipText ?? maxProgressString) : maxProgressString

        }
    }
    
    //当前左侧进度值
    @IBInspectable var leftProgress:CGFloat = 0 {
        didSet {
            layoutSublayersOfLayer(layer)
            leftButton.borderWidth = leftProgress == minProgress ? 0 : 2
            leftTip.hidden = leftProgress <= minProgress
            let minProgressString = "\(Int(leftProgress))"

            leftPinTextLayer.string = minProgressString
            leftTipTextLayer.string = leftProgress == minProgress ? (minTipText ?? minProgressString) : minProgressString
            leftTipTextLayer.foregroundColor = leftProgress == minProgress ? UIColor.lightGrayColor().CGColor : tintColor.CGColor
        }
    }
    //当前右侧进度值
    @IBInspectable var rightProgress:CGFloat = 100 {
        didSet {
            layoutSublayersOfLayer(layer)
            rightButton.borderWidth = rightProgress == maxProgress ? 0 : 2
            rightTip.hidden = rightProgress >= maxProgress
            let maxProgressString = "\(Int(rightProgress))"

            rightPinTextLayer.string = maxProgressString
            rightTipTextLayer.string = rightProgress == maxProgress ? (maxTipText ?? maxProgressString) : maxProgressString
            rightTipTextLayer.foregroundColor = rightProgress == maxProgress ? UIColor.lightGrayColor().CGColor : tintColor.CGColor
        }
    }
    
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        let centerY = bounds.height / 2 + 15
        let contentWidth:CGFloat = bounds.width - radius * 2
        progressBackground.frame = CGRectMake(radius, centerY, contentWidth, 2)
        let leftX = contentWidth * (leftProgress / maxProgress) + radius
        
        let rightX = contentWidth * (rightProgress / maxProgress) + radius
        let width = contentWidth * (rightProgress / maxProgress) - leftX + radius

        progressLine.frame = CGRectMake(leftX, 0, width, 2)
        
        leftButton.position = CGPointMake(leftX, centerY)
        rightButton.position = CGPointMake(rightX, centerY)
        
        leftTip.position = CGPointMake(leftX - radius, centerY - radius - 55)
        rightTip.position = CGPointMake(rightX - radius, centerY - radius - 55)
        leftTipTextLayer.position = CGPointMake(leftX, centerY - radius - 11)
        rightTipTextLayer.position = CGPointMake(rightX, centerY - radius - 11)
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        progressBackground.backgroundColor = UIColor.lightGrayColor().CGColor
        progressBackground.cornerRadius = 1
        layer.insertSublayer(progressBackground, atIndex: 0)
        
        progressLine.backgroundColor = tintColor?.CGColor
        progressBackground.addSublayer(progressLine)
        
        // 生成水滴形数字提示
        let pinlocationPath = UIBezierPath()
        pinlocationPath.moveToPoint(CGPointMake(36, 17.22))
        pinlocationPath.addCurveToPoint(CGPointMake(18.5, 51), controlPoint1: CGPointMake(36, 28.34), controlPoint2: CGPointMake(22.5, 51))
        pinlocationPath.addCurveToPoint(CGPointMake(1, 17.22), controlPoint1: CGPointMake(14.5, 51), controlPoint2: CGPointMake(1, 28.26))
        pinlocationPath.addCurveToPoint(CGPointMake(18.5, 0), controlPoint1: CGPointMake(1, 7.66), controlPoint2: CGPointMake(8.83, 0))
        pinlocationPath.addCurveToPoint(CGPointMake(36, 17.22), controlPoint1: CGPointMake(28.17, 0), controlPoint2: CGPointMake(36, 7.74))
        pinlocationPath.addLineToPoint(CGPointMake(36, 17.22))
        pinlocationPath.closePath()
        
        leftTip.path = pinlocationPath.CGPath
        leftTip.miterLimit = 4
        leftTip.fillColor = tintColor.CGColor
        leftTip.shadowColor = UIColor.darkGrayColor().CGColor
        leftTip.shadowOffset = CGSizeMake(2, 2)
        leftTip.shadowRadius = 5
        leftTip.shadowOpacity = 0.8
        leftTip.hidden = true
        
        rightTip.path = pinlocationPath.CGPath
        rightTip.miterLimit = 4
        rightTip.fillColor = tintColor.CGColor
        rightTip.shadowColor = UIColor.darkGrayColor().CGColor
        rightTip.shadowOffset = CGSizeMake(2, 2)
        rightTip.shadowRadius = 5
        rightTip.shadowOpacity = 0.8
        rightTip.hidden = true
        
        leftPinTextLayer.string = "\(Int(leftProgress))"
        leftPinTextLayer.alignmentMode = kCAAlignmentCenter
        leftPinTextLayer.fontSize = 16
        leftPinTextLayer.font = "HiraKakuProN-W3"
        leftPinTextLayer.frame = CGRectMake(0, 15, 32, 24)
        //解决CATextLayer在Retina屏幕绘制字体模糊的问题
        leftPinTextLayer.contentsScale = UIScreen.mainScreen().scale

        leftTip.addSublayer(leftPinTextLayer)
        
        rightPinTextLayer.string = "\(Int(rightProgress))"
        rightPinTextLayer.alignmentMode = kCAAlignmentCenter
        rightPinTextLayer.fontSize = 16
        rightPinTextLayer.font = "HiraKakuProN-W3"
        rightPinTextLayer.frame = CGRectMake(0, 15, 32, 24)
        //解决CATextLayer在Retina屏幕绘制字体模糊的问题
        rightPinTextLayer.contentsScale = UIScreen.mainScreen().scale
        
        rightTip.addSublayer(rightPinTextLayer)
        
        layer.addSublayer(leftTip)
        layer.addSublayer(rightTip)
        
        
        //提示文字
        leftTipTextLayer.alignmentMode = kCAAlignmentCenter
        leftTipTextLayer.fontSize = 14
        leftTipTextLayer.font = "HiraKakuProN-W3"
        leftTipTextLayer.frame = CGRectMake(0, 15, 32, 24)
        leftTipTextLayer.contentsScale = UIScreen.mainScreen().scale
        
        rightTipTextLayer.alignmentMode = kCAAlignmentCenter
        rightTipTextLayer.fontSize = 14
        rightTipTextLayer.font = "HiraKakuProN-W3"
        rightTipTextLayer.frame = CGRectMake(0, 0, 32, 24)
        rightTipTextLayer.contentsScale = UIScreen.mainScreen().scale


        
        layer.addSublayer(leftTipTextLayer)
        layer.addSublayer(rightTipTextLayer)
        
        
        leftButton.frame = CGRectMake(0, 0, 36, 36)
        leftButton.cornerRadius = 18
        leftButton.backgroundColor = UIColor.whiteColor().CGColor
        leftButton.shadowColor = UIColor.darkGrayColor().CGColor
        leftButton.shadowOffset = CGSizeMake(2, 2)
        leftButton.shadowRadius = 5
        leftButton.shadowOpacity = 0.8
        leftButton.borderColor = tintColor?.CGColor
        
        rightButton.frame = CGRectMake(0, 0, 36, 36)
        rightButton.cornerRadius = 18
        rightButton.backgroundColor = UIColor.whiteColor().CGColor
        rightButton.shadowColor = UIColor.darkGrayColor().CGColor
        rightButton.shadowOffset = CGSizeMake(2, 2)
        rightButton.shadowRadius = 5
        rightButton.shadowOpacity = 0.8
        rightButton.borderColor = tintColor?.CGColor
        
        layer.addSublayer(leftButton)
        layer.addSublayer(rightButton)
        
        
        //添加手势
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(DoubleSliderView.panButton(_:)))
        addGestureRecognizer(pan)
        
        self.leftProgress = minProgress
        self.rightProgress = maxProgress
        
        animateSpeed = 8

    }
    
    private var panningLayer:CALayer?

    func panButton(pan:UIPanGestureRecognizer) {
        let point = pan.locationInView(self)
        switch pan.state {
        case .Began:
            if CGRectContainsPoint(CGRectInset(rightButton.frame, -10, -10), point) {
                panningLayer = rightButton
                rightTipTextLayer.hidden = true
            } else if CGRectContainsPoint(CGRectInset(leftButton.frame, -10, -10), point) {
                panningLayer = leftButton
                leftTipTextLayer.hidden = true
            } else {
                leftTipTextLayer.hidden = false
                rightTipTextLayer.hidden = false
                panningLayer = nil
            }
         case .Changed:
            guard let selectLayer = panningLayer else {
                return
            }
            let oneWidth = (bounds.width - 2 * radius) / (maxProgress - minProgress) * spaceProgress
            let progress = ceil((point.x - radius) / oneWidth) * spaceProgress
            if selectLayer === leftButton {
                leftProgress = max(min(rightProgress - spaceProgress, progress), minProgress)
            } else if selectLayer === rightButton {
                rightProgress = max(min(maxProgress, progress), leftProgress + spaceProgress)
            }
        case .Ended:
            panningLayer = nil
            leftTip.hidden = true
            rightTip.hidden = true
            rightTipTextLayer.hidden = false
            leftTipTextLayer.hidden = false
        default:
            break
        }
    }
    

}
