//
//  DataTableViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/29.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class DataTableViewController: UITableViewController {

    lazy var dataSource:[String] = []    //数据源
    var imageView:UIImageView?      //空数据图片视图
    var label:UILabel?              //空数据文字label
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red:241/255,green:241/255,blue:241/255,alpha:1)
        
        imageView = UIImageView(image: UIImage(named: "empty_file"))
        label = UILabel()
        label!.text = "当前没有消息"
        label!.font = UIFont.systemFontOfSize(14)
        label!.textColor = UIColor(red:199/255,green:199/255,blue:199/255,alpha:1)
        label!.textAlignment = .Center
        
        tableView.addSubview(label!)
        tableView.addSubview(imageView!)

        changeTableStyle()
        
        //下拉刷新
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string:"下拉刷新")
        refresh.tintColor = UIColor(red:199/255,green:199/255,blue:199/255,alpha:1)
        refresh.addTarget(self, action: #selector(DataTableViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
    }
    
    
    func changeTableStyle() {
        imageView?.hidden = dataSource.count != 0
        label?.hidden = dataSource.count != 0
        //如果Table不是Group风格，我们需要设置分割线的风格
        tableView.separatorStyle = dataSource.count == 0 ? .None : .SingleLine
    }
    
    
    var queue:NSOperationQueue = NSOperationQueue()
    func refreshData() {
        self.refreshControl?.attributedTitle = NSAttributedString(string:"正在刷新...")
        queue.addOperationWithBlock {
            for i:Int in 0  ..< 10 {
                self.dataSource.append("\(i)")
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock{
                self.refreshControl!.attributedTitle = NSAttributedString(string:"下拉刷新")
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                self.changeTableStyle()
            }
        }
        
    }
    

    override func viewWillLayoutSubviews() {
        imageView!.frame = CGRectMake((tableView.bounds.width - 66)/2, (tableView.bounds.height - 66)/2 - 64 - 10, 66, 66)
        label!.frame = CGRectMake((tableView.bounds.width - 100)/2, imageView!.frame.origin.y + imageView!.frame.height + 10, 100, 30)

    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }



}
