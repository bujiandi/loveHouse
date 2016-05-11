//
//  FilterTableViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/8.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    
    @IBOutlet var typicalButtons: [UIButton]!
    
    
    @IBOutlet var yearButtons: [UIButton]!
    
    
    @IBOutlet weak var sliderView: DoubleSliderView! {
        didSet {
            sliderView.layer.cornerRadius = 2
            sliderView.layer.borderWidth = 0.5
            sliderView.layer.borderColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1).CGColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 228/255,green:76/255,blue:27/255,alpha:1)
        for button in yearButtons {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1).CGColor
            button.layer.cornerRadius = 2
            button.addTarget(self, action: #selector(FilterTableViewController.yearButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        
        for button in typicalButtons {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1).CGColor
            button.layer.cornerRadius = 2
            button.addTarget(self, action: #selector(FilterTableViewController.typicalButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    func typicalButtonClick(sender:UIButton) {
        sender.selected = !sender.selected
        sender.layer.borderColor = sender.selected ? view.tintColor.CGColor : UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1).CGColor
    }
    
    
    func yearButtonClick(sender:UIButton) {
        for button in yearButtons {
            if button === sender {
                button.selected = true
                button.layer.borderColor = view.tintColor.CGColor
            } else {
                button.selected = false
                button.layer.borderColor = UIColor(red:204/255,green:204/255,blue:204/255,alpha: 1).CGColor
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
