//
//  ViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/13.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var searchButton:UIButton!
    @IBOutlet weak var topContainer:UIView!
    @IBOutlet weak var shadowView:UIView!
    
    
    @IBAction func onListTapping(sender:AnyObject!) {
        
        if let controller = storyboard?.instantiateViewControllerWithIdentifier("FilterTableViewController") {
            controller.view.frame.size.height = UIScreen.mainScreen().bounds.height - 200
            
            presentSemiViewController(controller)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置搜索按钮圆角
        searchButton.layer.cornerRadius  = 4
     
        // 设置按钮容器圆角 且 子视图不超过圆角范围
        topContainer.layer.masksToBounds = true
        topContainer.layer.cornerRadius = 3
        
        // 设置阴影视图背景透明且 增加引用
        shadowView.backgroundColor = UIColor.clearColor()
        shadowView.layer.shadowOffset  = CGSizeMake(0, 1)
        shadowView.layer.shadowColor   = UIColor.grayColor().CGColor
        shadowView.layer.shadowRadius  = 4
        shadowView.layer.shadowOpacity = 0.8


    }
    
    @IBAction func onPopupButtonTapped(button:UIButton) {
        performSegueWithIdentifier("popoverSegue", sender: button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.view.frame.size.width = view.bounds.width
            var frame = sender!.frame
            frame.origin.y = 0
            popoverViewController.popoverPresentationController?.sourceRect = frame
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    


}

