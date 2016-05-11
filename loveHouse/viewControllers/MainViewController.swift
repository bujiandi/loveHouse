//
//  MainViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/6.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var tabBar:UITabBar!

    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //给底部工具条添加阴影
        tabBar.layer.shadowOffset  = CGSizeMake(0, 1)
        tabBar.layer.shadowColor   = UIColor.grayColor().CGColor
        tabBar.layer.shadowRadius  = 4
        tabBar.layer.shadowOpacity = 0.8
        
        // 默认选中第一项
        tabBar.selectedItem = tabBar.items?.first
        tabBar(tabBar,didSelectItem: tabBar.items!.first!)
        tabBar.items![1].badgeValue = "1"
        view.makeToast(message: "为您找到1003处房源", duration: 1, y: 120)
        
        let alert:CLAlertView = CLAlertView(title: "测试", contentText:
            "1223333", leftTitle:"取消", rigthTitle: "确定")
        alert.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        contentView.subviews.first?.removeFromSuperview()
        childViewControllers.first?.removeFromParentViewController()
        var controller:UIViewController = UIViewController()
        switch item.tag {
        case 10001:
            controller = storyboard!.instantiateViewControllerWithIdentifier("mapViewController")
        case 10002:
            controller = storyboard!.instantiateViewControllerWithIdentifier("BookingViewController")
        case 10003:
            controller = storyboard!.instantiateViewControllerWithIdentifier("HouseViewController")
        case 10004:
            controller = storyboard!.instantiateViewControllerWithIdentifier("UserTableViewController")
        default:
            break
        }
        controller.view.frame = self.contentView.bounds
        contentView.addSubview(controller.view)
        addChildViewController(controller)
        
    }
    


}
