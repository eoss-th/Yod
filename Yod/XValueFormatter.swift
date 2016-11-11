//
//  XValueFormatter.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/11/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation
import Charts

class XValueFormatter : NSObject, IAxisValueFormatter {
    
    var values: [String]
    
    init (values: [String]) {
        self.values = values
    }
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        let index = Int(value)
        if index < values.count {
            return values[Int(value)]
        }
        return ""
    }
    
}
