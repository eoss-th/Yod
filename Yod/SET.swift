//
//  Symbol.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/8/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation

struct SETHistorical {
    let asOfDate:String
    let assets:Float
    let liabilities:Float
    let equity:Float
    let paidUpCapital:Float
    let revenue:Float
    let netProfit:Float
    let eps:Float
    let roa:Float
    let roe:Float
    let netProfitMargin:Float
    let dvdYield:Float
    
    init (_ asOfDate:String, assets:Float, liabilities:Float, equity:Float, paidUpCapital:Float, revenue:Float, netProfit:Float, eps:Float, roa:Float, roe:Float, netProfitMargin:Float, dvdYield:Float) {
        self.asOfDate = asOfDate
        self.assets = assets
        self.liabilities = liabilities
        self.equity = equity
        self.paidUpCapital = paidUpCapital
        self.revenue = revenue
        self.netProfit = netProfit
        self.eps = eps
        self.roa = roa
        self.roe = roe
        self.netProfitMargin = netProfitMargin
        self.dvdYield = dvdYield
    }
}

class SET {
    
    static let csvURL = "http://eoss-setfin.appspot.com/csv?"
    static let indexURL = "http://eoss-setfin.appspot.com/SETIndexServlet"
    static let historicalURL = "http://eoss-setfin.appspot.com/his?s="
    
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
    var histories = [SETHistorical]()
    
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
            } else if g > 0 {
                netGrowth = net + Swift.abs(net) * g/100.0
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
        
        if symbol == "IEC" {
            print (values["Net Growth %"]!)
            print (values["NG/E"]!)
            print (net)
            print (netGrowth)
            print (equity)
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
        
        //Cleansing Data for Sorting
        if let pe = values["P/E"] {
            
            if pe == 0 {
                values["P/E"] = Float.infinity
            }
        } else {
            values["P/E"] = Float.infinity
        }
        
        if let _ = values["Last"] {
            
        } else {
            values["Last"] = 0
        }
        
        if let _ = values["Net Growth %"] {
            
        } else {
            values["Net Growth %"] = 0
        }
        
        if let _ = values["E/A Growth %"] {
            
        } else {
            values["E/A Growth %"] = 0
        }
        
        if let _ = values["Predict MA"] {
            
        } else {
            values["Predict MA"] = 0
        }
        
        if let _ = values["Predict Chg %"] {
            
        } else {
            values["Predict Chg %"] = 0
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
    
    func loadHistoricals () {
        var s = symbol!.replacingOccurrences(of: "&", with: "%26")
        s = s.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: SET.historicalURL + s) {
            if let data = try? String(contentsOf: url) {
                let lines = data.components(separatedBy: "\n")
                
                for i in 1..<lines.count {
                    let columns = lines[i].components(separatedBy: ",")
                    
                    if columns.count >= 12 {
                        histories.append(SETHistorical(columns[0],
                            assets: Float(columns[1])!,
                            liabilities:Float(columns[2])!,
                            equity:Float(columns[3])!,
                            paidUpCapital:Float(columns[4])!,
                            revenue:Float(columns[5])!,
                            netProfit:Float(columns[6])!,
                            eps:Float(columns[7])!,
                            roa:Float(columns[8])!,
                            roe:Float(columns[9])!,
                            netProfitMargin:Float(columns[10])!,
                            dvdYield:Float(columns[11])!
                        ))
                    }
                }
            }
        }
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
                if val != Float.infinity {
                    total += val
                    count += 1
                }
            }
        }
        
        return total / count
    }
    
}

