//
//  WebViewController.swift
//  loveHouse
//
//  Created by C Lau. on 16/4/21.
//  Copyright © 2016年 C Lau. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    /*
     To have an accurate UIProgressView, you need to have some task that:
     
     You can get information from while it isn't complete
     Quantify its "completeness" as a percentage based on that information.
     Now when you are loading your UIWebView, thats not possible. And Apple doesn't do it either. Apple often uses fake UIProgressViews to give you something to look at while the page is loading. Mail also uses fake progress views. Go try it out for yourself. This is how Apple's fake progress views work:
     
     The progress view starts moving at a slow, constant rate
     If the task finishes before the bar completes, it suddenly zips across the rest to 100% before disappearing
     If the task takes a long time, the progress view will stop at 95% and will stay there until the task is complete.
     */
    
    
    @IBOutlet weak var processView: UIProgressView! {
        didSet {
            processView.progress = 0
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    var myTimer:NSTimer?
    var finished:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string:"https://www.github.com")
        webView.loadRequest(NSURLRequest(URL: url!))
    }

    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        processView.progress = 0
        finished = false
        //0.01667 is roughly 1/60, so it will update at 60 FPS
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(WebViewController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        finished = true
    }
    
    func timerCallback() {
        if (finished) {
            if (processView.progress >= 1) {
                processView.hidden = true
                myTimer?.invalidate()
            }
            else {
                processView.progress += 0.1
            }
        }
        else {
            processView.progress += 0.05
            if (processView.progress >= 0.95) {
                processView.progress = 0.95
            }
        }

    }
    
    
}
