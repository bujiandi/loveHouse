//
//  MessageViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/7.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    

    @IBOutlet var tabView: ScrollTabView!
    
    override func viewWillLayoutSubviews() {
        tabView.contentOffset = 64
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        tabView.contentOffset = navigationController!.navigationBar.frame.height + 24
        tabView.contents = [(title:"动态",image:nil,storyboardID:"DataTableViewController"),
                            (title:"提醒",image:nil,storyboardID:"DataTableViewController"),
                            (title:"公告",image:nil,storyboardID:"DataTableViewController")
                            ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    



}
