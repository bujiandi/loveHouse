//
//  StepperView.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/11.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class StepperView: UIView {
    //进度条高度
    var progressHeight:CGFloat = 3
    //圆形进度视图半径
    var stepRadius:CGFloat = 16
    //完成的背景颜色
    var completedBgColor:UIColor = UIColor(red:0/255,green:192/255,blue:165/255,alpha: 1)
    //未完成的背景颜色
    var unCompletedBgColor:UIColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1)

    //未完成进度视图
    let backgroundLine:UIView = UIView()
    //完成的进度视图
    let progressLine:UIView = UIView()

    //当前步骤
    var currentStep:Int = 0
    
    //图片和文字数组
    var stepContents:[(image:UIImage, title:String)] = [] {
        didSet {
            if superview == nil { return }
            addStepContentsToView()
            setNeedsLayout()
        }
    }
    
    private func addStepContentsToView() {
        subviews.forEach { $0.removeFromSuperview() }
        
        backgroundLine.backgroundColor = unCompletedBgColor
        
        addSubview(backgroundLine)
        
        progressLine.backgroundColor = completedBgColor
        backgroundLine.addSubview(progressLine)
        
        for (image, title) in stepContents {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .Center
            imageView.layer.cornerRadius = stepRadius
            addSubview(imageView)
            
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFontOfSize(12)
            addSubview(label)
        }
        
    }
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        addStepContentsToView()
    }

    override func layoutSubviews() {
        let length = CGFloat(stepContents.count) - 1

        let backgroundLine = subviews[0]
        let width = bounds.width - stepRadius * 2
        backgroundLine.frame = CGRectMake(stepRadius, (bounds.height - progressHeight) / 2, width, progressHeight)
        let progressLine = backgroundLine.subviews[0]
        //计算当前进度的宽
        let halfWidth = 1 / length * width / 2
        progressLine.frame = CGRectMake(0, 0, min(CGFloat(currentStep) / length * width - halfWidth, width), progressHeight)
        
        let centerY = bounds.height / 2
        var index:Int = 0
        for i in 1.stride(to: subviews.count, by: 2) {
            let itemX = stepRadius + (CGFloat(index) / length) * width
            let imageView = subviews[i]
            
            imageView.frame.size = CGSizeMake(stepRadius * 2, stepRadius * 2)
            imageView.center = CGPointMake(itemX, centerY)
            //如果index小于当前步骤，说明index都是已经完成的步骤，我们可以设置imageView的背景颜色为completedBgColor
            imageView.backgroundColor = index < currentStep ? completedBgColor : unCompletedBgColor
            
            let label = subviews[i + 1] as! UILabel
            label.sizeToFit()
            label.center = CGPointMake(itemX, centerY + stepRadius + label.frame.height)
            //如果index小于当前步骤，说明index都是已经完成的步骤，我们可以设置label的文字颜色为completedBgColor
            label.textColor = index < currentStep ? completedBgColor : UIColor.grayColor()
            index += 1
        }

    }
    
    
}
