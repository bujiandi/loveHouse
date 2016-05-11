//
//  CLAlertView.swift
//  socialHelper
//
//  Created by C Lau on 15/7/13.
//  Copyright © 2015年 C Lau. All rights reserved.
//

import UIKit

class CLAlertView: UIView {
    //弹框的宽度
    let kAlertWidth:CGFloat =  245
    //弹框的高度
    let kAlertHeight:CGFloat = 160
    
    //弹框标题
    var alertTitleLabel:UILabel?
    //弹框内容
    var alertContentLabel:UILabel?
    //左侧按钮
    var leftBtn:UIButton?
    //右侧按钮
    var rightBtn:UIButton?
    //背景视图
    var backImageView:UIView?
    
    //左侧按钮回调方法
    var leftBlock:dispatch_block_t?
    //右侧按钮回调方法
    var rightBlock:dispatch_block_t?
    //关闭弹框回调方法
    var dismissBlock:dispatch_block_t?
    
    
    //标题的Y轴偏移量
    let kTitleYOffset:CGFloat = 15
    //标题的高度
    let kTitleHeight:CGFloat = 25
    
    //内容的偏移量
    let kContentOffset:CGFloat = 30
    //两个label之间的偏移量
    let kBetweenLabelOffset:CGFloat = 20


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(title:String,contentText:String,leftTitle:String?,rigthTitle:String) {
        super.init(frame:CGRect.zero)
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.whiteColor()
        self.alertTitleLabel = UILabel(frame: CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight))
        self.alertTitleLabel!.font = UIFont.boldSystemFontOfSize(20)
        self.alertTitleLabel!.textColor = UIColor(red: 56.0/255, green: 64/255, blue: 71/255, alpha: 1)
        self.addSubview(self.alertTitleLabel!)
        let contentLabelWidth:CGFloat = kAlertWidth - 16
        
        self.alertContentLabel = UILabel(frame: CGRectMake((kAlertWidth - contentLabelWidth) * CGFloat(0.5),CGRectGetMaxY(self.alertTitleLabel!.frame), contentLabelWidth, CGFloat(60)))

        self.alertContentLabel!.numberOfLines = 0
        self.alertContentLabel!.textAlignment = NSTextAlignment.Center
        self.alertTitleLabel!.textAlignment = NSTextAlignment.Center
        
        self.alertContentLabel!.textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
            
        self.alertContentLabel!.font = UIFont.systemFontOfSize(15)
        self.addSubview(self.alertContentLabel!)
        
        
        var leftBtnFrame:CGRect?
        var rightBtnFrame:CGRect?
        
        
        let kSingleButtonWidth:CGFloat = 160
        let kCoupleButtonWidth:CGFloat = 107
        let kButtonHeight:CGFloat = 40
        let kButtonBottomOffset:CGFloat = 10
        
        if leftTitle == nil {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight)
            self.rightBtn = UIButton(type: UIButtonType.Custom)
            self.rightBtn!.frame = rightBtnFrame!
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight)
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame!) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight)
            self.leftBtn = UIButton(type: UIButtonType.Custom)
            self.rightBtn = UIButton(type: UIButtonType.Custom)
            self.leftBtn!.frame = leftBtnFrame!
            self.rightBtn!.frame = rightBtnFrame!
        }
        
        if self.rightBtn != nil {
            self.rightBtn!.backgroundColor = UIColor(red: 87.0/255.0, green: 135.0/255.0, blue: 173.0/255.0, alpha: 1)
            self.rightBtn!.setTitle(rigthTitle, forState: UIControlState.Normal)
            self.rightBtn!.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            self.rightBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.rightBtn!.addTarget(self, action: #selector(CLAlertView.rightBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.rightBtn!.layer.masksToBounds = true
            self.rightBtn!.layer.cornerRadius = 3
            self.addSubview(rightBtn!)
        }
        
        if self.leftBtn != nil {
            self.leftBtn!.backgroundColor = UIColor(red: 227.0/255.0, green: 100.0/255.0, blue: 83.0/255.0, alpha: 1)
            if leftTitle != nil {
                self.leftBtn!.setTitle(leftTitle!, forState: UIControlState.Normal)
            }
            
            self.leftBtn!.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            self.leftBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.leftBtn!.addTarget(self, action: #selector(CLAlertView.leftBtnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.leftBtn!.layer.masksToBounds = true
            self.leftBtn!.layer.cornerRadius = 3
            self.addSubview(leftBtn!)
        }
        
        
        self.alertTitleLabel?.text = title
        self.alertContentLabel?.text = contentText

        
        let xButton:UIButton = UIButton(type: .Custom)
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32)
        self.addSubview(xButton)
        xButton.addTarget(self, action: #selector(CLAlertView.dismissAlert), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.autoresizingMask = [.FlexibleBottomMargin , .FlexibleLeftMargin , .FlexibleRightMargin ,.FlexibleTopMargin]
        
    }
    
    
    func leftBtnClicked(sender:AnyObject) {
        dismissAlert()
        if self.leftBlock != nil {
            self.leftBlock!()
        }
        
    }
    
    
    func rightBtnClicked(sender:AnyObject) {
        dismissAlert()
        if self.rightBlock != nil {
            self.rightBlock!()
        }
        
    }

    
    
    func show() {
        let topVC:UIViewController = self.appRootViewController()
        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, -kAlertHeight - 30, kAlertWidth, kAlertHeight)
        topVC.view.addSubview(self)

    }
    
    
    func appRootViewController() -> UIViewController {
        let appRootVC:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)!
        var topVC:UIViewController = appRootVC
        while ((topVC.presentedViewController) != nil) {
            topVC = topVC.presentedViewController!
        }
        return topVC
    }
    
    func dismissAlert() {
        self.removeFromSuperview()
        if self.dismissBlock != nil {
            self.dismissBlock!()
        }
    }

    
    override func removeFromSuperview() {
        self.backImageView?.removeFromSuperview()
        self.backImageView = nil
        let topVC:UIViewController = appRootViewController()
        let afterFrame:CGRect = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight)
        
        UIView.animateWithDuration(0.35, delay: 0, options: .CurveEaseOut, animations: {
            self.frame = afterFrame
            self.transform = CGAffineTransformMakeRotation(0)
            
            }) { (finished) -> Void in
                super.removeFromSuperview()
        }
        
    }
    

    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if (newSuperview == nil) {
            return
        }
        
        let topVC:UIViewController = appRootViewController()
        if self.backImageView == nil {
            self.backImageView = UIView(frame: topVC.view.bounds)
            self.backImageView!.backgroundColor = UIColor.blackColor()
            self.backImageView!.alpha = 0.6
            self.backImageView!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight ,UIViewAutoresizing.FlexibleWidth]
        }
        
        topVC.view.addSubview(self.backImageView!)
        self.transform = CGAffineTransformMakeRotation(0)//CGAffineTransformMakeRotation(CGFloat(-M_1_PI / 2))
        let afterFrame:CGRect = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight)
        

        UIView.animateWithDuration(0.35, delay: 0, options: .CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeRotation(0)
            self.frame = afterFrame
        }) { finished in
            
        }
        super.willMoveToSuperview(newSuperview)
        
    }
    
    
    
    

}
