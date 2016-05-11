//
//  Toast+UIView.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/8.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

extension UIView {
    
    private func viewForMessage(msg: String,positionY:CGFloat) -> UIView {
        let toastView = UIView()
        toastView.backgroundColor = UIColor.blackColor()
        toastView.alpha = 0.6
        toastView.layer.cornerRadius = 4
        toastView.frame = CGRectMake(8, positionY, bounds.width - 16, 40)
        let textLabel = UILabel()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.text = msg
        textLabel.frame = toastView.bounds
        toastView.addSubview(textLabel)
        return toastView
    }
    
    
    private func showToast(toastView:UIView,duration:Double) {
        addSubview(toastView)
        UIView.animateWithDuration(duration, delay: 1, options: ([.CurveEaseOut]),
            animations: {
                toastView.alpha = 0
            },
            completion: { (finished: Bool) in
                self.hideToast(toastView)
        })
    }
    
    private func hideToast(toast:UIView) {
        toast.removeFromSuperview()
    }
    
    func makeToast(message msg: String, duration: Double, y: CGFloat) {
        let toastView = viewForMessage(msg,positionY: y)
        showToast(toastView,duration: duration)
    }

    
}