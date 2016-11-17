//
//  Symbol.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/8/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation

class SET {
    
    static let csvURL = "http://eoss-setfin.appspot.com/csv?"
    static let indexURL = "http://eoss-setfin.appspot.com/SETIndexServlet"
    
    static var cache = [SET]()
    static var filters = [SET]()
    static var toggles = [String:Bool]()
    static var industries = [String]()
    static var sections = [String:[String]]()
    
    static var roeMean = Float(0)
    static var netGrowthMean = Float(0)
    static var growthMean = Float(0)
    static var peMean = Float(0)
    
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
        
        var netGrowth:Float=0
        if let g = values["Net Growth %"] {
            if net < 0 && g < 0 {
                netGrowth = net - net * g/100.0
            } else {
                netGrowth = net + net * g/100.0
            }
        }
        
        if netGrowth != 0 {
            values["N/NG"] = net / netGrowth
        } else {
            values["N/NG"] = 1
        }
        
        //Trim
        values["NG/E"] = netGrowth / equity
        if let nge = values["NG/E"] {
            if (Swift.abs(nge)>1) {
                values["NG/E"] = nge/Swift.abs(nge)
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
        
        //Cleansing Data
        if let _ = values["P/E"] {
            
        } else {
            values["P/E"] = -0
        }
        
        if let _ = values["Last"] {
            
        } else {
            values["Last"] = 0
        }
        
    }
    
    class func create() -> Bool {
        let setURL = csvURL + String(arc4random_uniform(1000))
        
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
            
            updateMeans()
            
            if let url = URL(string: indexURL) {
                let text = try! String(contentsOf: url)
                let lines = text.components(separatedBy: "\n")
                for line in lines {
                    if line.isEmpty {
                        continue
                    }
                    var names = line.components(separatedBy: ",")
                    let sector = names[0]
                    names.remove(at: 0)
                    sections[sector] = names.sorted()
                }
                
                industries = sections.keys.sorted()
                
            }
            
            industries.remove(at: 0)
            
            
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
            
            let left, right: Float
            
            left = $0.values[field]!
            right = $1.values[field]!
            
            return operand (left, right)
        }
    }
    
    class func removeFilter () {
        filters = cache
        updateMeans()
    }
    
    class func applyFilter (symbols:[String]) {
        var newFilter = [SET]()
        for set in filters {
            
            for symbol in symbols {
                if (set.symbol?.hasPrefix(symbol))! {
                    newFilter.append(set)
                }
            }
        }
        
        filters = newFilter
    }
    
    class func applyFilter (industry:String, sector:String) {
        filters.removeAll()
        
        for set in cache {
            if set.industry == industry && set.sector == sector {
                filters.append(set)
            }
        }
        updateMeans()
    }
    
    class func applyFilter (field:String, operand:(Float, Float)->Bool, value:Float) {
        
        var newFilter = [SET]()
        for set in filters {
            if let val = set.values[field] {
                if operand(val, value) {
                    newFilter.append(set)
                }
            }
        }
        
        filters = newFilter
    }
    
    class func updateMeans () {
        roeMean = mean("ROE")
        netGrowthMean = mean("Net Growth %")
        growthMean = mean("E/A Growth %")
        peMean = mean("P/E")
    }
    
    class func mean(_ field:String) -> Float {
        
        var total:Float = 0
        var count:Float = 0
        
        for set in filters {
            if let val = set.values[field] {
                total += val
                count += 1
            }
        }
        
        return total / count
    }
    
}

