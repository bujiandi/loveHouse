//
//  HouseViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/29.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class HouseViewController: UIViewController {

    @IBOutlet weak var imageView: ImageScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contents = [(image:"house-1.jpg",isVideo:false),(image:"house-2.jpg",isVideo:false),(image:"house-3.jpg",isVideo:true)]
    }
}

