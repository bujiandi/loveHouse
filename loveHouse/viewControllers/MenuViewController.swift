//
//  MenuViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/26.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeMenuClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
