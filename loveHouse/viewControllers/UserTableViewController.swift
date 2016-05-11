//
//  UserTableViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/5/6.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    @IBOutlet weak var profileView: UIImageView! {
        didSet {
            profileView.layer.cornerRadius = 30
            profileView.layer.masksToBounds = true
            profileView.layer.borderColor = UIColor(red:247/255,green:247/255,blue:247/255,alpha:1.0).CGColor
            profileView.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var profileCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileCell.backgroundView = UIImageView(image: UIImage(named: "bg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("WebViewController")
            parentViewController?.navigationController?.pushViewController(controller, animated: true)
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("MessageViewController")
            parentViewController?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }

}
