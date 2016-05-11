//
//  UIViewController+Semi.swift
//  QuestionLib
//
//  Created by 慧趣小歪 on 16/5/10.
//  Copyright © 2016年 小分队. All rights reserved.
//

import UIKit

//定义通知
let kSemiModalDidShowNotification       = "kSemiModalDidShowNotification"
let kSemiModalDidHideNotification       = "kSemiModalDidHideNotification"
let kSemiModalWasResizedNotification    = "kSemiModalWasResizedNotification"

//属性key
let kSemiModalViewController            = "PaPQC93kjgzUanz"
let kSemiModalDismissBlock              = "l27h7RU2dzVfPoQ"

//视图的tag
let kSemiModalOverlayTag                = 43001
let kSemiModalScreenshotTag             = 43002
let kSemiModalModalViewTag              = 43003
let kSemiModalDismissButtonTag          = 43004

//模态过度风格
public enum KNSemiModalTransitionStyle: UInt {
    case SlideUp
    case FadeInOut
    case FadeIn
    case FadeOut
}

public struct KNSemi {
    public static var presentingViewController:UIViewController?
}

public class KNSemiModalOptionSets {
    //参数单例
    public static var defaultOptions:KNSemiModalOptionSets = KNSemiModalOptionSets()
    //返回父视图是否使用动画
    public var pushParentBack:Bool = true
    //动画间隔
    public var animationDuration:NSTimeInterval = 0.5
    //父视图透明度
    public var parentAlpha:CGFloat = 0.5
    //父视图缩放比例
    public var parentScale:CGFloat = 0.8
    //阴影透明度
    public var shadowOpacity:Float = 0.8
    //模态过度风格
    public var transitionStyle = KNSemiModalTransitionStyle.SlideUp
    //是否可取消
    public var disableCancel:Bool = true
    //背景图层
    public var backgroundView:UIView?
    
    //设置父视图是否使用动画
    public func setPushParentBack(back:Bool) -> KNSemiModalOptionSets {
        pushParentBack = back
        return self
    }
    //设置动画间隔
    public func setAnimationDuration(duration:NSTimeInterval) -> KNSemiModalOptionSets {
        animationDuration = duration
        return self
    }
    
    //设置父视图透明度
    public func setParentAlpha(alpha:CGFloat) -> KNSemiModalOptionSets {
        parentAlpha = alpha
        return self
    }
    //设置父视图缩放
    public func setParentScale(scale:CGFloat)  -> KNSemiModalOptionSets {
        parentScale = scale
        return self
    }
    //设置阴影透明度
    public func setShadowOpacity(opacity:Float) -> KNSemiModalOptionSets {
        shadowOpacity = opacity
        return self
    }
    //设置模态过渡风格
    public func setTransitionStyle(style:KNSemiModalTransitionStyle) -> KNSemiModalOptionSets {
        transitionStyle = style
        return self
    }
    //设置是否可取消
    public func setDisableCancel(cancel:Bool) -> KNSemiModalOptionSets {
        disableCancel = cancel
        return self
    }
    //设置背景视图
    public func setBackgroundView(view:UIView?) -> KNSemiModalOptionSets {
        backgroundView = view
        return self
    }
}

extension UIViewController {
    
    // MARK: - KNSemiModalInternal
    //创建动画组
    private func animationGroupForward(_forward:Bool) -> CAAnimationGroup {
        var t1 = CATransform3DIdentity
        t1.m34 = 1.0 / -900
        t1 = CATransform3DScale(t1, 0.95, 0.95, 1)
        if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
            t1 = CATransform3DRotate(t1, 7.5 * CGFloat(M_PI) / 180.0, 1, 0, 0)
        } else {
            t1 = CATransform3DRotate(t1, 15.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
        }
        
        var t2 = CATransform3DIdentity
        t2.m34 = t1.m34
        
        let options = KNSemiModalOptionSets.defaultOptions
        
        let parentTarget = self.view
        
        let scale:CGFloat = options.parentScale
        if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
            t2 = CATransform3DTranslate(t2, 0, parentTarget.frame.size.height * -0.04, 0)
            t2 = CATransform3DScale(t2, scale, scale, 1)
        } else {
            t2 = CATransform3DTranslate(t2, 0, parentTarget.frame.size.height * -0.08, 0)
            t2 = CATransform3DScale(t2, scale, scale, 1)
        }
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.toValue = NSValue(CATransform3D: t1)
        let duration:NSTimeInterval = options.animationDuration
        animation.duration = duration / 2
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let animation2 = CABasicAnimation(keyPath: "transform")
        animation2.toValue = NSValue(CATransform3D: _forward ? t2 : CATransform3DIdentity)
        animation2.beginTime = animation.duration
        animation2.duration = animation.duration

        animation2.fillMode = kCAFillModeForwards
        animation2.removedOnCompletion = false
        
        let group = CAAnimationGroup()
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        
        group.duration = animation.duration * 2
        group.animations = [animation, animation2]
        return group
    }
    
    //屏幕方向改变
    public func kn_interfaceOrientationDidChange(notification:NSNotification) {
        if let overlay = self.view.viewWithTag(kSemiModalOverlayTag) {
            kn_addOrUpdateParentScreenshotInView(overlay)
        }
    }
    
    //添加或更新父视图控制器的屏幕截图
    private func kn_addOrUpdateParentScreenshotInView(screenshotContainer:UIView) -> UIImageView {
        let target = self.view
        let semiView = target.viewWithTag(kSemiModalModalViewTag)
        
        screenshotContainer.hidden = true
        semiView?.hidden = true
        UIGraphicsBeginImageContextWithOptions(target.bounds.size, true, UIScreen.mainScreen().scale)
        target.drawViewHierarchyInRect(target.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        screenshotContainer.hidden = false
        semiView?.hidden = false
        
        var screenshot:UIImageView! = screenshotContainer.viewWithTag(kSemiModalScreenshotTag) as? UIImageView
        if screenshot != nil {
            screenshot.image = image
        } else {
            screenshot = UIImageView(image: image)
            screenshot.tag = kSemiModalScreenshotTag
            screenshot.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            screenshotContainer.addSubview(screenshot)
        }
        return screenshot
    }
  
    // MARK: - KNSemiModal
    //present一个视图控制器
    public func presentSemiViewController(controller:UIViewController, onComplete:(()->())? = nil) {
        presentSemiViewController(controller, withOptions:nil, onComplete:onComplete)
    }
    
    //present一个视图控制器
    public func presentSemiViewController(controller:UIViewController, withOptions options:KNSemiModalOptionSets?, onComplete:(()->())? = nil) {
        
        self.addChildViewController(controller)

        objc_setAssociatedObject(self, kSemiModalViewController, controller, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        presentSemiView(controller.view, withOptions:options) {
            controller.didMoveToParentViewController(self)
            onComplete?()
        }
    }
    //present一个视图
    public func presentSemiView(view:UIView, onComplete:(()->())? = nil) {
        presentSemiView(view, withOptions: nil, onComplete: onComplete)
    }
    //present一个视图
    public func presentSemiView(view:UIView, withOptions options:KNSemiModalOptionSets?, onComplete:(()->())? = nil) {
        
        KNSemiModalOptionSets.defaultOptions = options ?? KNSemiModalOptionSets()
        let options = KNSemiModalOptionSets.defaultOptions
        
        let target = self.view //parentTarget
        
        if !target.subviews.contains(view) {
            KNSemi.presentingViewController = self
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.kn_interfaceOrientationDidChange(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
            
            // Get transition style
            let transitionStyle = options.transitionStyle

        
            let semiViewHeight = view.frame.height
            let vf = target.bounds
            
            var semiViewFrame = CGRectZero
            if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
                semiViewFrame = CGRectMake((vf.size.width - view.frame.size.width) / 2.0, vf.size.height-semiViewHeight, view.frame.size.width, semiViewHeight)
            } else {
                semiViewFrame = CGRectMake(0, vf.size.height-semiViewHeight, vf.size.width, semiViewHeight)
            }
            
            let overlayFrame = CGRectMake(0, 0, vf.size.width, vf.size.height-semiViewHeight)
            let backgroundView:UIView? = options.backgroundView
            let overlay:UIView = backgroundView ?? UIView()
            overlay.frame = target.bounds
            overlay.backgroundColor = UIColor.blackColor()
            overlay.userInteractionEnabled = true
            overlay.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            overlay.tag = kSemiModalOverlayTag
            
            let ss = kn_addOrUpdateParentScreenshotInView(overlay)
            target.addSubview(overlay)
            
            if options.disableCancel {
                let dismissButton = UIButton(type: .Custom)
                dismissButton.addTarget(self, action: #selector(UIViewController.dismissSemiModalView), forControlEvents: .TouchUpInside)
                dismissButton.backgroundColor = UIColor.clearColor()
                dismissButton.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
                dismissButton.frame = overlayFrame;
                dismissButton.tag = kSemiModalDismissButtonTag
                overlay.addSubview(dismissButton)
            }
            
            if options.pushParentBack {
                ss.layer.addAnimation(animationGroupForward(true), forKey: "pushedBackAnimation")
            }
            
            let duration:NSTimeInterval = options.animationDuration
            UIView.animateWithDuration(duration) {
                ss.alpha = options.parentAlpha
            }
            view.frame = transitionStyle == .SlideUp
                ? CGRectOffset(semiViewFrame, 0, +semiViewHeight)
                : semiViewFrame
            if (transitionStyle == .FadeIn || transitionStyle == .FadeInOut) {
                view.alpha = 0.0;
            }
            if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
                view.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
            } else {
                view.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
            }
            
            view.tag = kSemiModalModalViewTag
            target.addSubview(view)
            view.layer.shadowColor = UIColor.blackColor().CGColor
            view.layer.shadowOffset = CGSizeMake(0, -2)
            view.layer.shadowRadius = 5.0
            view.layer.shadowOpacity = options.shadowOpacity
            view.layer.shouldRasterize = true
            view.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            UIView.animateWithDuration(duration, animations: { 
                if (transitionStyle == .SlideUp) {
                    view.frame = semiViewFrame;
                } else if (transitionStyle == .FadeIn || transitionStyle == .FadeInOut) {
                    view.alpha = 1.0;
                }
            }) {
                if !$0 { return }
                NSNotificationCenter.defaultCenter().postNotificationName(kSemiModalDidShowNotification, object: self)
                onComplete?()
            }
        }
    }
    //更新父视图的背景截图
    public func updateBackground() {
        if let overlay = self.view.viewWithTag(kSemiModalOverlayTag) {
            kn_addOrUpdateParentScreenshotInView(overlay)
        }
    }
    //关闭模态视图
    public func dismissSemiModalView() {
        dismissSemiModalViewWithCompletion(nil)
    }
    //关闭模态视图（带回调方法）
    public func dismissSemiModalViewWithCompletion(onComplete:(()->())?) {
        guard let presentingController = KNSemi.presentingViewController else {
            return
        }
        
        if presentingController !== self {
            presentingController.dismissSemiModalViewWithCompletion(onComplete)
            return
        }
        
        let options = KNSemiModalOptionSets.defaultOptions
        
        let parent = presentingController //kn_parentTargetViewController
        let target = presentingController.view //parentTarget
        let modal:UIView! = target.viewWithTag(kSemiModalModalViewTag)
        let overlay:UIView! = target.viewWithTag(kSemiModalOverlayTag)
        
        let transitionStyle = options.transitionStyle
        let duration = options.animationDuration
        let controller = objc_getAssociatedObject(parent, kSemiModalViewController) as? UIViewController
        let onDismiss = objc_getAssociatedObject(parent, kSemiModalDismissBlock) as? ()->()
        
        controller?.willMoveToParentViewController(nil)
        UIView.animateWithDuration(duration, animations: { 
            if transitionStyle == .SlideUp {
                if case .Pad = UIDevice.currentDevice().userInterfaceIdiom {
                    // As the view is centered, we perform a vertical translation
                    modal?.frame = CGRectMake((target.bounds.size.width - modal.frame.size.width) / 2.0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
                } else {
                    modal?.frame = CGRectMake(0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
                }
            } else {
                modal?.alpha = 0.0
            }
        }) { finish in
            overlay?.removeFromSuperview()
            modal?.removeFromSuperview()
            
            controller?.removeFromParentViewController()
            
            onDismiss?()
            
            objc_setAssociatedObject(parent, kSemiModalDismissBlock, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            objc_setAssociatedObject(parent, kSemiModalViewController, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
            
        }
        
        let ss = overlay?.subviews[0] as? UIImageView
        if options.pushParentBack {
            ss?.layer.addAnimation(animationGroupForward(false), forKey: "bringForwardAnimation")
        }
        
        UIView.animateWithDuration(duration, animations: { 
            ss?.alpha = 1
        }) { finish in
            if finish {
                NSNotificationCenter.defaultCenter().postNotificationName(kSemiModalDidHideNotification, object: self)
                
                onComplete?()
            }
        }
    }
    //设置模态视图的尺寸
    public func resizeSemiView(newSize:CGSize) {
        let target = self.view
        guard let modal = target.viewWithTag(kSemiModalModalViewTag) else {
            return
        }
        var mf = modal.frame
        mf.size.width = newSize.width
        mf.size.height = newSize.height
        mf.origin.y = target.frame.size.height - mf.size.height
        
        let overlay = target.viewWithTag(kSemiModalOverlayTag)
        let button = target.viewWithTag(kSemiModalDismissButtonTag)
        
        var bf = button?.frame ?? CGRectZero
        bf.size.height = (overlay?.frame.size.height ?? 0) - newSize.height
        let duration = KNSemiModalOptionSets.defaultOptions.animationDuration
        UIView.animateWithDuration(duration, animations: { 
            modal.frame = mf
            button?.frame = bf
        }) {
            if $0 { NSNotificationCenter.defaultCenter().postNotificationName(kSemiModalWasResizedNotification, object: self) }
        }
        
        
    }
}
