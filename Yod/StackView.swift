//
//  StackView.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class StackView: UIView {
    
    var stacks = [StackView]()
    
    func add(value:CGFloat, percentChg:Float, color:UIColor) -> StackView {
        
        let width = value * self.frame.width
        
        let stackView = StackView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        stackView.backgroundColor = color
        
        if percentChg != 0 {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = stackView.frame
            
            if percentChg >= 0 {
                gradientLayer.colors = [color, color, UIColor.green]
            } else {
                gradientLayer.colors = [color, color, UIColor.gray]
            }
            
            let pos = 1 - Swift.abs(percentChg)/100
            
            gradientLayer.locations = [0.0, NSNumber(value: pos), 1.0]
            stackView.layer.addSublayer(gradientLayer)
        }
        
        self.addSubview(stackView)
        stacks.append(stackView)
        return stackView
    }
    
    func clear() {
        for s in stacks.reversed() {
            s.removeFromSuperview()
        }
        stacks.removeAll()
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
