//
//  ImageScrollView.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/29.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class ImageScrollView: UIView,UIScrollViewDelegate {

    private var _currentPage:Int = 0    // 当前页面
    private var _imageViews:[UIImageView] = [] // 图片数组

    var pageControl:UIPageControl?
    var countLabel:UILabel?
    var scrollView:UIScrollView = UIScrollView()
    var contents:[(image:String,isVideo:Bool)] = [] {
        didSet {
            for content in contents {
                let imageView = UIImageView()
                imageView.contentMode = .ScaleAspectFill
                imageView.image = UIImage(named:content.image)
                scrollView.addSubview(imageView)
                _imageViews.append(imageView)
            }
            countLabel?.text = "\(_currentPage+1)/\(_imageViews.count)"
        }
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        pageControl = UIPageControl()
        pageControl!.hidesForSinglePage = true
        pageControl?.addTarget(self, action: #selector(ImageScrollView.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
        countLabel = UILabel()
        countLabel?.backgroundColor = UIColor.blackColor()
        countLabel?.alpha = 0.6
        countLabel?.textColor = UIColor.whiteColor()
        countLabel?.textAlignment = .Center
        countLabel?.font = UIFont.systemFontOfSize(12)
        countLabel?.layer.masksToBounds = true
        countLabel?.layer.cornerRadius = 4
        addSubview(countLabel!)
        addSubview(pageControl!)
    }
    
    func changePage(sender:UIPageControl) {
        _currentPage = sender.currentPage
        countLabel?.text = "\(_currentPage+1)/\(_imageViews.count)"
        UIView.animateWithDuration(0.3, animations: {
            self.scrollView.contentOffset = CGPointMake(self.bounds.width * CGFloat(self._currentPage), 0)
        })
    }
    
    //-TODO:计算布局
    override func layoutSubviews() {
        //计算每个ImageView的布局
        for i:Int in 0 ..< _imageViews.count {
            let imageView = _imageViews[i]
            imageView.frame = CGRectMake(CGFloat(i) * bounds.width, 0, bounds.width, bounds.height)
        }
        scrollView.frame = bounds
        let pagesScrollViewSize = scrollView.frame.size
        self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(_imageViews.count), height: pagesScrollViewSize.height)
        pageControl!.frame = CGRectMake(0, bounds.height - 30, bounds.width, 30)
        pageControl!.numberOfPages = _imageViews.count
        countLabel?.frame = CGRectMake(bounds.width - 60,bounds.height - 31, 50, 21)
        loadVisiblePage()
    }
    
    
    func loadVisiblePage() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index in firstPage...lastPage {
            index = index == -1 ? 0 : index
            _currentPage = index
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        _currentPage = page

        pageControl!.currentPage = _currentPage
        countLabel?.text = "\(_currentPage+1)/\(_imageViews.count)"

    }

    
    
}
