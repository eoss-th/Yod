//
//  Symbol.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/8/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation

class Symbol {
    
    var industry:String?
    var sector:String?
    var symbol:String?
    var date:String?
    var xd:String?
    var dvd:String?
    
    var values = [String:Float]()
    
    init(line:String) {
        let tokens = line.components(separatedBy: ",")
        
        industry = tokens[0]
        sector = tokens[1]
        symbol = tokens[2]
        date = tokens[3]
        values["E/A Growth %"] = Float(tokens[4])
        values["Revenue Growth %"] = Float(tokens[5])
        values["Net Growth %"] = Float(tokens[6])
        values["EPS Growth %"] = Float(tokens[7])
        values["ROE Growth %"] = Float(tokens[8])
        values["Margin Growth %"] = Float(tokens[9])
        values["DVD Growth %"] = Float(tokens[10])
        values["EPS"] = Float(tokens[11])
        values["ROA"] = Float(tokens[12])
        values["ROE"] = Float(tokens[13])
        values["Margin"] = Float(tokens[14])
        values["Last"] = Float(tokens[15])
        values["P/E"] = Float(tokens[16])
        values["P/BV"] = Float(tokens[17])
        values["DVD %"] = Float(tokens[18])
        values["Market Cap:Estimated E"] = Float(tokens[19])
        values["Estimated Asset"] = Float(tokens[20])
        values["Estimated Equity"] = Float(tokens[21])
        values["Estimated Revenue"] = Float(tokens[22])
        values["Estimated Net"] = Float(tokens[23])
        dvd = tokens[24]
        xd = tokens[25]
        values["Predict MA"] = Float(tokens[26])
        values["Predict Chg %"] = Float(tokens[27])
        
    }
}
