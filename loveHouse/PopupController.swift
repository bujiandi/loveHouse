//
//  PopupController.swift
//  loveHouse
//
//  Created by 慧趣小歪 on 16/4/23.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class PopupController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum DataType {
        case Area       //区域
        case SubWay     //地铁
    }
    
    @IBOutlet weak var thirdTableWidthConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var firstTableView: UITableView! {
        didSet {
            firstTableView.delegate = self
            firstTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var secondTableView: UITableView! {
        didSet {
            secondTableView.delegate = self
            secondTableView.dataSource = self
        }

    }
    
    @IBOutlet weak var thirdTableView: UITableView! {
        didSet {
            thirdTableView.delegate = self
            thirdTableView.dataSource = self
        }
    }
    
    private var _selectedRow:Int = 0
    
    lazy var datas:[AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //默认一开始不显示第三层
        thirdTableWidthConstraint.constant = 0
        dataFromJson(.Area)

    }
    
    
    func dataFromJson(type:DataType) {
        let jsonPath:String = NSBundle.mainBundle().bundlePath + "/data.json"
        let data = NSData(contentsOfFile:jsonPath)
        let dic = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        if type == .Area {
            let city = (dic["areas"] as! [AnyObject]).first as! [NSObject:AnyObject]
            datas = city["area"] as! [AnyObject]
        }
        
        if type == .SubWay {
            datas = dic["subways"] as! [AnyObject]
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === firstTableView {
            return 2
        }
        if tableView === secondTableView {
            return datas.count
        }
        if tableView === thirdTableView {
            let data = datas[_selectedRow] as! [NSObject:AnyObject]
            let places = data["place"]
            return places?.count ?? 0
        }
        return 0
    }
    
    let cellIdentifier:String = "levelCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("levelCell")
        cell!.textLabel?.highlightedTextColor = view.tintColor
        cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        if tableView === firstTableView {
            cell!.textLabel?.text = indexPath.row == 0 ? "区域" : "地铁"
        }
        
        if tableView === secondTableView {
            let data = datas[indexPath.row] as! [NSObject:AnyObject]
            cell!.textLabel?.text = data["name"] as? String ?? ""
        }
        
        if tableView === thirdTableView {
            let data = datas[_selectedRow] as! [NSObject:AnyObject]
            if let places = data["place"] as? [[NSObject:AnyObject]] {
                let place = places[indexPath.row]
                cell!.textLabel?.text = place["name"] as? String ?? ""
            }
            
        }
        
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === firstTableView {
            _selectedRow = indexPath.row

            thirdTableWidthConstraint.constant = 0
            //如果是第一列，我们需要判断点击的是第几行cell，然后切换数据源
            if indexPath.row == 0 {
                dataFromJson(.Area)
            }
            
            if indexPath.row == 1 {
                dataFromJson(.SubWay)
            }
            secondTableView.reloadData()
        }
        if tableView === secondTableView {
            _selectedRow = indexPath.row
            thirdTableWidthConstraint.constant = view.bounds.width / 3
            thirdTableView.reloadData()
        }
        if tableView === thirdTableView {
            
        }
    }
    
    
    
    
    

}

