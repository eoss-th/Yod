//
//  SlideTabBarController.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/10/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class SlideTabBarController: UITabBarController {
    
    var stringURL = "http://eoss-setfin.appspot.com/csv?"
    
    var symbols = [Symbol]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(SlideTabBarController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        */
        
        DispatchQueue.global().async {
            
            self.stringURL += String(arc4random_uniform(1000))
            if let url = URL(string: self.stringURL) {
                let text = try! String(contentsOf: url)
                var lines = text.components(separatedBy: "\n")
                lines.remove(at: 0)
                for line in lines {
                    if line.isEmpty {
                        continue
                    }
                    self.symbols.append(Symbol(line: line))
                }
            }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        
        let assetTableViewController = self.viewControllers![0] as! AssetTableViewController
        assetTableViewController.tableView.reloadData()
        
    }
    
    func rotated()
    {
        /*
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("landscape")
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait")
        }
        */
    }
}
