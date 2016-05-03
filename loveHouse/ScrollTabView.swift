//
//  ScrollTabView.swift
//  DidiTaxi
//
//  Created by C Lau. on 16/4/9.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class ScrollTabView: UIView,UIScrollViewDelegate {
    private var toolBarView:UIView?
    private var _currentPage:Int = 0
    private var scrollView:UIScrollView! {
        didSet {
            scrollView.pagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.delegate = self
        }
    }
    var contentOffset:CGFloat = 110
    private var viewControllerIDs:[String] = []
        var contents:[(title:String,image:String?,storyboardID:String)] = [] {
            didSet {
                for _ in 0..<contents.count {
                    self.pageViews.append(nil)
                }
                toolBarView = UIView(frame:CGRectMake(0, contentOffset, UIScreen.mainScreen().bounds.width, 44))
                scrollView = UIScrollView(frame: CGRect(x: 0, y: contentOffset + toolBarView!.bounds.height, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - (contentOffset+toolBarView!.frame.height)))
                buttons.forEach({ $0.removeFromSuperview() })
                buttons = []
                for (title,image,storybardID) in contents {
                    viewControllerIDs.append(storybardID)
                    let button = UIButton(type:.Custom)
                    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
                    button.titleLabel?.font = UIFont.systemFontOfSize(13)
                    button.setTitleColor(UIColor.grayColor(), forState: .Normal)
                    button.setTitleColor(UIColor(red:253/255,green:152/255,blue:64/255,alpha:1), forState: .Highlighted)
                    button.setTitle(title, forState: .Normal)
                    if let icon = image {
                        button.setImage(UIImage(named:icon), forState: UIControlState.Normal)
                        button.setImage(UIImage(named:icon+"_highlight"), forState: UIControlState.Highlighted)
                    }
                    button.userInteractionEnabled = false
                    button.sizeToFit()
                    button.frame.origin.y = (44 - button.frame.height)/2
                    
                    buttons.append(button)
                    toolBarView!.addSubview(button)
                    addSubview(toolBarView!)
                    addSubview(scrollView!)
                }
            }
        }
    
    private var buttons:[UIButton] = []
    let borderLayer:CALayer = CALayer()

    let averageSpace:CGFloat = 20

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubViews()
    }

    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        for button in buttons where button.superview == nil {
            toolBarView?.addSubview(button)
        }
        
        //为UIView添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(ScrollTabView.onTap(_:)))
        toolBarView?.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self,action: #selector(ScrollTabView.onScroll(_:)))
        toolBarView?.addGestureRecognizer(pan)
        
        borderLayer.frame = CGRectMake(0, 30, 0, 2)
        borderLayer.backgroundColor = UIColor(red:253/255,green:152/255,blue:64/255,alpha:1).CGColor
        toolBarView?.layer.insertSublayer(borderLayer, atIndex: 0)
        let pagesScrollViewSize = self.scrollView.frame.size
        self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(viewControllerIDs.count), height: pagesScrollViewSize.height)
        
        self.loadVisiblePages()
        updateSubViews()
    }
    
    
    func onScroll(pan:UIPanGestureRecognizer) {
        highlightedButtonAtPoint(pan.locationInView(toolBarView!))
    }

    //手势点击方法
    func onTap(tap:UITapGestureRecognizer) {
        //获取当前点击的坐标
        highlightedButtonAtPoint(tap.locationInView(toolBarView!))
    }
    

    func highlightButtonAtIndex(index:Int) {
        _currentPage = index

        let button = buttons[index]
        button.highlighted = true
        for i:Int in 0..<buttons.count where i != index {
            buttons[i].highlighted = false
        }
        
//        let spring = CASpringAnimation(keyPath: "position.x")
//        spring.damping = 5
//        spring.fromValue = borderLayer.position.x
//        spring.toValue = button.layer.position.x
//        spring.duration = spring.settlingDuration;
//        spring.initialVelocity = 10
//        borderLayer.addAnimation(spring, forKey: nil)
//
        borderLayer.frame.size.width = button.frame.width + 5
        borderLayer.frame.origin.x = button.frame.minX - 5
    }
    
    func highlightedButtonAtPoint(point:CGPoint) {
        var index:Int = -1
        for i in 0..<buttons.count {
            let btn = buttons[i]
           //循环判断点击区域在哪个button范围内
            if CGRectContainsPoint(btn.frame, point) {
                index = i
                break
            }
        }
        
        if index == -1 { return }
        
        
        let pagesScrollViewSize = scrollView.frame.size
        
        UIView.animateWithDuration(0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: pagesScrollViewSize.width * CGFloat(index), y: 0)
        })
        
        highlightButtonAtIndex(index)
    }
    
    
    func loadVisiblePages() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index in firstPage...lastPage {
            index = index == -1 ? 0 : index
            _currentPage = index
            loadPage(index)
        }
        highlightButtonAtIndex(page)
    }

    
    
    private var pageViews = [UIViewController?]()
    func loadPage(page: Int) {
        guard page >= 0 && page < viewControllerIDs.count else { return }
        guard pageViews[page] == nil else { return }
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        let newPageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIDs[page])

        newPageView.view.frame = frame
        scrollView.addSubview(newPageView.view)
        
        pageViews[page] = newPageView
    }
    
    
    
    func updateSubViews() {
        let pageCount = viewControllerIDs.count
        toolBarView?.frame = CGRectMake(0, contentOffset, UIScreen.mainScreen().bounds.width, 44)
        var offsetX:CGFloat = averageSpace
        for i:Int in 0..<buttons.count {
            let button = buttons[i]
            button.frame.origin.x = offsetX
            offsetX += button.frame.size.width + averageSpace
            
            if button.highlighted {
                borderLayer.frame.origin.x = button.frame.origin.x - 5
                borderLayer.frame.origin.y = button.frame.origin.y + button.frame.height 
            }
        }
        scrollView.frame = CGRectMake(0, contentOffset + toolBarView!.frame.height, bounds.width, bounds.height - (contentOffset + toolBarView!.frame.height))
        scrollView.contentSize = CGSize(width: CGFloat(pageCount) * scrollView.frame.width, height: scrollView.frame.height)
        for (index, controller) in pageViews.enumerate() {
            controller?.view.frame = CGRect(x: CGFloat(index) * scrollView.frame.size.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        self.scrollView.contentOffset = CGPoint(x: pagesScrollViewSize.width * CGFloat(self._currentPage), y: 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let t = scrollView.contentOffset.x % pageWidth
        let p = scrollView.contentOffset.x / pageWidth
        var page = Int(p + (t > 0 ? 1 : 0))
        
        if page >= viewControllerIDs.count{
            page = viewControllerIDs.count - 1
        } else if page < 0 {
            page = 0
        }
        highlightButtonAtIndex(page)
    }
    
    

}
