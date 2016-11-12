//
//  SlideTabBarController.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/10/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class SlideTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SlideTabBarController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rotated () {
        
        let assetTableViewController = self.viewControllers![0] as! AssetTableViewController
        assetTableViewController.tableView.reloadData()
        
        let chartViewController = self.viewControllers![1] as! ChartViewController
        chartViewController.rotated()
    }
    
}
