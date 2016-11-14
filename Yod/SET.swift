//
//  Symbol.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/8/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation

class SET {
    
    static let stringURL = "http://eoss-setfin.appspot.com/csv?"
    static var cache = [SET]()
    static var filters = [SET]()
    static var toggles = [String:Bool]()
    
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
        
        var asset:Float=1
        if let a = values["Estimated Asset"] {
            if a != 0 {
                asset = a
            }
        }
        
        var equity:Float=1
        if let e = values["Estimated Equity"] {
            if e != 0 {
                equity = e
            }
        }
        
        var net:Float=0
        if let n = values["Estimated Net"] {
            net = n
        }
        
        var equityGrowth:Float=0
        if let g = values["E/A Growth %"] {
            
            var growthRate = g/100.0
            if growthRate < 0 {
                growthRate *= -1
            }
            equityGrowth = equity + equity * growthRate
        }
        
        values["N/E"] = net / equity
        
        if let ne = values["N/E"] {
            if (Swift.abs(ne)>1) {
                values["N/E"] = ne/Swift.abs(ne)
            }
        }
        
        if equityGrowth != 0 {
            values["E/G"] = equity / equityGrowth
        } else {
            values["E/G"] = 1
        }
        
        if equityGrowth > asset {
            equityGrowth = asset
        }
        
        values["G/A"] = equityGrowth / asset
        
    }
    
    class func create() -> Bool {
        let setURL = stringURL + String(arc4random_uniform(1000))
        
        if let url = URL(string: setURL) {
            let text = try! String(contentsOf: url)
            var lines = text.components(separatedBy: "\n")
            lines.remove(at: 0)
            var set:SET
            for line in lines {
                if line.isEmpty {
                    continue
                }
                set = SET(line: line)
                if set.industry != "-" {
                    cache.append(set)
                }
                filters = cache
            }
            return true
        }
        
        return false
    }
    
    class func toggleSort (_ field:String) {
        
        var toggleValue:Bool
        if let value = toggles[field] {
            toggleValue = !value
        } else {
            toggleValue = true
        }
        
        toggles.removeAll()
        
        if toggleValue {
            if field == "P/E" {
                self.toggleSort(field, operand: <)
            } else {
                self.toggleSort(field, operand: >)
            }
        } else {
            if field == "P/E" {
                self.toggleSort(field, operand: >)
            } else {
                self.toggleSort(field, operand: <)
            }
        }
        
        self.toggles[field] = toggleValue
    }
    
    class func toggleSort (_ field:String, operand:(Float, Float)->Bool) {
        
        filters = filters.sorted {
            
            let left, right:Float
            
            if let l = $0.values[field] {
                left = l
            } else {
                left = 0
            }
            
            if let r = $1.values[field] {
                right = r
            } else {
                right = 0
            }
            
            return operand (left, right)
        }
    }
    
    class func removeFilter () {
        filters = cache
    }
    
    class func applyFilter (industry:String, sector:String) {
        filters.removeAll()
        
        for set in cache {
            if set.industry == industry && set.sector == sector {
                filters.append(set)
            }
        }
    }
    
}
