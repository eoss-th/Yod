//
//  Yahoo.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/11/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation

struct YahooHistorical {
    
    let date:Date
    let open:Float
    let high:Float
    let low:Float
    let close:Float
    let volume:Int
    
    init (date:Date, open:Float, high:Float, low:Float, close:Float, volume: Int) {
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}

class Yahoo {
    
    let YAHOO_URL = "http://ichart.finance.yahoo.com/table.csv?a=01&b=01&c=2010&s="
    
    let dateFormatter = DateFormatter()
    
    let symbol:String
    
    var histories=[YahooHistorical]()
    
    var closes=[Float]()
    
    var ema5=[Float]()
    
    var ema20=[Float]()
    
    var ema80=[Float]()
    
    var lastClose=Float(0)
    
    var lastEMA5=Float(0)
    
    var lastEMA20=Float(0)
    
    var lastEMA80=Float(0)
    
    var deltaEMA5_80=Float(0)
    
    var deltaEMA20_80=Float(0)
    
    var trend=Float(0)
    
    init (symbol:String) {
        
        self.symbol = symbol
        var s = symbol
        //var s = symbol.stringByReplacingOccurrencesOfString("&", withString: "%26")
        s = s.replacingOccurrences(of: " ", with: "%20")
        s += ".BK"
        if let url = URL(string: YAHOO_URL + s) {
            if let data = try? String(contentsOf: url) {
                let lines = data.components(separatedBy: "\n")
                
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                for i in 1..<lines.count {
                    let columns = lines[i].components(separatedBy: ",")
                    
                    if columns.count > 5 {
                        histories.append(YahooHistorical(date: dateFormatter.date(from: columns[0])!,
                                                    open:Float(columns[1])!,
                                                    high:Float(columns[2])!,
                                                    low:Float(columns[3])!,
                                                    close:Float(columns[4])!,
                                                    volume:Int(columns[5])!))
                    }
                }
                
                histories = histories.reversed()
                for r in histories {
                    closes.append(r.close)
                }
                lastClose = closes[closes.count-1]
                
                if closes.count >= 80 {
                    ema5 = ema(closes: closes, days: 5)
                    lastEMA5 = ema5[ema5.count-1]
                    
                    ema20 = ema(closes: closes, days: 20)
                    lastEMA20 = ema20[ema20.count-1]
                    
                    ema80 = ema(closes: closes, days: 80)
                    lastEMA80 = ema80[ema80.count-1]
                    
                    deltaEMA5_80 = (lastEMA5 - lastEMA80)/lastEMA80
                    
                    deltaEMA20_80 = (lastEMA20-lastEMA80)/lastEMA80
                    
                    if deltaEMA20_80 > 0 {
                        trend = (deltaEMA5_80 - deltaEMA20_80)*100
                    } else {
                        trend = (deltaEMA5_80 + deltaEMA20_80)*100
                    }
                }
            }
        }

    }
    
    func ma(closes:[Float], days:Int) -> [Float] {
        var mas = [Float]()
        //Days=3: 0,0,X
        for _ in 0..<days - 1 {
            mas.append(0)
        }
        
        let priceList = closes
        for i in 0..<priceList.count {
            var totalPrice = Float(0)
            if i+days <= priceList.count {
                for j in i..<i+days {
                    totalPrice += priceList[j]
                }
                mas.append(totalPrice/Float(days))
            } else {
                break
            }
        }
        
        return mas
    }
    
    func ema(closes:[Float], days:Int) -> [Float] {
        
        var emas = [Float]()
        
        if closes.count >= days {
            //Days=3: 0,0,X
            var totalPrice = Float(0)
            for i in 0..<days {
                emas.append(0)
                totalPrice += closes[i]
            }
            
            //Fist EMA
            emas [days-1] = totalPrice / Float(days)
            let multiplier = Float(2) / Float(days + 1)
            
            for i in days..<closes.count {
                emas.append(emas[i-1] + multiplier * (closes[i]-emas[i-1]))
            }
        }
        
        return emas
    }
    
}
