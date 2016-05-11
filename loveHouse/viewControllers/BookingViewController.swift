//
//  BookingViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/11.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class BookingViewController: UITableViewController {

    @IBOutlet weak var stepperView: StepperView!
    override func viewDidLoad() {
        super.viewDidLoad()
        stepperView.stepContents = [
            (image:UIImage(named:"building")!,title:"1.挑选房源"),
            (image:UIImage(named:"calendar_white")!,title:"2.预约时间"),
            (image:UIImage(named:"correct")!,title:"3.提交成功")
        ]
        stepperView.currentStep = 1
        self.title = "约看清单"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
