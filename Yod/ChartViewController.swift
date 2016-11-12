//
//  ChartViewController.swift
//  Yod
//
//  Created by Wisarut Srisawet on 11/11/16.
//  Copyright © 2016 Enterprise Open Source Solution. All rights reserved.
//

import Foundation
import Charts

class ChartViewController : UIViewController {
    
    let dateFormatter = DateFormatter()
    
    let DAYS = [7, 30, 90, 180, 365, 365*3, 365*6]
    
    var daysIndex = 0
    
    @IBOutlet weak var containerView: UIView!
    
    var yahoo:Yahoo?
    
    var candleDataSet:CandleChartDataSet?
    
    var closeDataSet:LineChartDataSet?
    
    var ma5DataSet:LineChartDataSet?
    
    var ma20DataSet:LineChartDataSet?
    
    var ma80DataSet:LineChartDataSet?
    
    var volumeDataSet:BarChartDataSet?
    
    var predictDataSet:LineChartDataSet?
    
    override func viewDidLoad() {
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let combinedChartView = CombinedChartView()
        
        combinedChartView.noDataText = "Please select a symbol"
        
        combinedChartView.frame = containerView.bounds
        containerView.addSubview(combinedChartView)
    }
    
    @IBAction func loadWeek(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 0
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    @IBAction func loadMonth(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 1
            DispatchQueue.global().async {
                self.chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
                DispatchQueue.main.async {
                    self.containerView.setNeedsDisplay()
                }
            }
        }
    }
    @IBAction func load3Months(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 2
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    @IBAction func load6Months(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 3
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    @IBAction func loadYear(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 4
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    @IBAction func load3Years(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 5
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    @IBAction func load6Years(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            daysIndex = 6
            chartLoadSymbol(description: yahoo.symbol, yahoo: yahoo)
        }
    }
    
    internal func chartLoadSymbol(description:String, yahoo:Yahoo, daysIndex:Int=0) {
        
        for v in containerView.subviews {
            v.removeFromSuperview()
        }
        
        containerView.setNeedsDisplay()
        
        let combinedChartView = CombinedChartView()
        combinedChartView.frame = containerView.bounds
        
        combinedChartView.noDataText = "Please select a symbol"
        
        /*
         combinedChartView.backgroundColor = UIColor.black
         combinedChartView.noDataTextColor = UIColor.white
         combinedChartView.tintColor = UIColor.white
         combinedChartView.borderColor = UIColor.white
         combinedChartView.gridBackgroundColor = UIColor.white
         combinedChartView.legend.textColor = UIColor.white
         combinedChartView.chartDescription?.textColor = UIColor.white
         
         combinedChartView.rightAxis.zeroLineColor = UIColor.white
         combinedChartView.rightAxis.gridColor = UIColor.white
         combinedChartView.rightAxis.axisLineColor = UIColor.white
         combinedChartView.rightAxis.labelTextColor = UIColor.white
         
         combinedChartView.leftAxis.zeroLineColor = UIColor.white
         combinedChartView.leftAxis.gridColor = UIColor.white
         combinedChartView.leftAxis.axisLineColor = UIColor.white
         combinedChartView.leftAxis.labelTextColor = UIColor.white
         
         combinedChartView.xAxis.gridColor = UIColor.white
         combinedChartView.xAxis.labelT
         combinedChartView.xAxis.axisLineColor = UIColor.white
         combinedChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
         */
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        
        self.yahoo = yahoo
        self.daysIndex = daysIndex
        
        combinedChartView.chartDescription?.text = description
        
        closeDataSet = LineChartDataSet (values: createCloseDataEntries(), label: "Close")
        closeDataSet!.circleRadius = 0
        closeDataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        closeDataSet!.setColor(NSUIColor.gray)
        
        ma5DataSet = LineChartDataSet (values: createEMA5DataEntries(), label: "EMA5")
        ma5DataSet!.circleRadius = 0
        ma5DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma5DataSet?.valueTextColor = NSUIColor.white
        //ma5DataSet?.highlightColor = NSUIColor.white
        ma5DataSet!.setColor(NSUIColor.green)
        
        ma20DataSet = LineChartDataSet (values: createEMA20DataEntries(), label: "EMA20")
        ma20DataSet!.circleRadius = 0
        ma20DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma20DataSet?.valueTextColor = NSUIColor.white
        //ma20DataSet?.highlightColor = NSUIColor.white
        ma20DataSet!.setColor(NSUIColor.cyan)
        
        ma80DataSet = LineChartDataSet (values: createEMA80DataEntries(), label: "EMA80")
        ma80DataSet!.circleRadius = 0
        ma80DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma80DataSet?.valueTextColor = NSUIColor.white
        //ma80DataSet?.highlightColor = NSUIColor.white
        ma80DataSet!.setColor(NSUIColor.orange)
        
        let lineData = LineChartData()
        //lineData.addDataSet(closeDataSet)
        lineData.addDataSet(ma5DataSet)
        lineData.addDataSet(ma20DataSet)
        lineData.addDataSet(ma80DataSet)
        
        candleDataSet = CandleChartDataSet (values: createHiLoDataEntries(), label: "Candle")
        candleDataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        //candleDataSet?.valueTextColor = NSUIColor.white
        //candleDataSet?.highlightColor = NSUIColor.white
        candleDataSet?.increasingFilled = true
        candleDataSet?.setColor(UIColor(netHex:0xb4ecb4))
        candleDataSet?.increasingColor = UIColor(netHex:0xb4ecb4)
        candleDataSet?.decreasingColor = UIColor(netHex:0xffb2ae)
        
        let candleData = CandleChartData()
        candleData.addDataSet(candleDataSet)
        
        volumeDataSet = BarChartDataSet (values: createVolumeDataEntries(), label: "Volume")
        //volumeDataSet?.valueTextColor = NSUIColor.white
        //volumeDataSet?.highlightColor = NSUIColor.white
        volumeDataSet?.setColor(UIColor(netHex:0xf2f2ef))
        volumeDataSet?.axisDependency = combinedChartView.leftAxis.axisDependency
        
        let barData = BarChartData()
        barData.addDataSet(volumeDataSet)
        
        combinedChartView.xAxis.valueFormatter = XValueFormatter(values: createDates())
        
        let data = CombinedChartData()
        data.lineData = lineData
        data.candleData = candleData
        data.barData = barData
        
        //Reset View
        combinedChartView.data = data
        
        combinedChartView.fitScreen()
        
        combinedChartView.leftAxis.axisMinimum = (volumeDataSet?.yMin)!
        combinedChartView.leftAxis.axisMaximum = (volumeDataSet?.yMax)! * 3
        combinedChartView.leftAxis.spaceTop = 20
        //combinedChartView.leftAxis.enabled = false
        
        combinedChartView.rightAxis.axisMinimum = (closeDataSet?.yMin)! * 0.95
        combinedChartView.rightAxis.axisMaximum = (closeDataSet?.yMax)! * 1.05
        combinedChartView.rightAxis.spaceTop = 20
        
        combinedChartView.moveViewToX(Double(lineData.dataSets.count - 1))
        
        containerView.addSubview(combinedChartView)
    }
    
    func createCloseDataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var closeDataEntries = [ChartDataEntry]()
        var i = 0
        let closes = yahoo?.closes
        if limit > closes!.count {
            limit = closes!.count
        }
        for j in closes!.count-limit..<closes!.count {
            closeDataEntries.append(ChartDataEntry(x: Double(i), y: Double(closes![j])))
            i += 1
        }
        
        return closeDataEntries
    }
    
    func createEMA5DataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var maDataEntries = [ChartDataEntry]()
        var i = 0
        let mas = yahoo?.ema5
        if limit > mas!.count {
            limit = mas!.count
        }
        for j in mas!.count-limit..<mas!.count {
            maDataEntries.append(ChartDataEntry(x: Double(i), y: Double(mas![j])))
            i += 1
        }
        return maDataEntries
    }
    
    func createEMA20DataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var maDataEntries = [ChartDataEntry]()
        var i = 0
        let mas = yahoo?.ema20
        if limit > mas!.count {
            limit = mas!.count
        }
        for j in mas!.count-limit..<mas!.count {
            maDataEntries.append(ChartDataEntry(x: Double(i), y: Double(mas![j])))
            i += 1
        }
        return maDataEntries
    }
    
    func createEMA80DataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var maDataEntries = [ChartDataEntry]()
        var i = 0
        let mas = yahoo?.ema80
        if limit > mas!.count {
            limit = mas!.count
        }
        for j in mas!.count-limit..<mas!.count {
            maDataEntries.append(ChartDataEntry(x: Double(i), y: Double(mas![j])))
            i += 1
        }
        return maDataEntries
    }
    
    func createHiLoDataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var hiloDataEntries = [ChartDataEntry]()
        var i = 0
        let histories = yahoo?.histories
        if limit > histories!.count {
            limit = histories!.count
        }
        for j in histories!.count-limit..<histories!.count {
            let h = histories![j]
            hiloDataEntries.append(CandleChartDataEntry(x: Double(i), shadowH: Double(h.high),
                                                        shadowL: Double(h.low), open: Double(h.open), close: Double(h.close)))
            i += 1
        }
        return hiloDataEntries
    }
    
    func createVolumeDataEntries () -> [ChartDataEntry] {
        var limit = DAYS[daysIndex]
        var volumeDataEntries = [ChartDataEntry]()
        var i = 0
        let histories = yahoo?.histories
        if limit > histories!.count {
            limit = histories!.count
        }
        for j in histories!.count-limit..<histories!.count {
            let h = histories![j]
            volumeDataEntries.append(BarChartDataEntry(x: Double(i), y: Double(h.volume/1000)))
            i += 1
        }
        return volumeDataEntries
    }
    
    
    func createDates () -> [String] {
        
        var limit = DAYS[daysIndex]
        
        if (daysIndex<2) {
            dateFormatter.dateFormat = "MMM dd"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        
        var dates = [String]()
        var i = 0
        let histories = yahoo?.histories
        if limit > histories!.count {
            limit = histories!.count
        }
        for j in histories!.count-limit..<histories!.count {
            dates.append(dateFormatter.string(from: histories![j].date))
            i += 1
        }
        //dates.append("Next Day")
        return dates
    }
    
    func createPredictDataEntries (predicts:[Double]) -> [ChartDataEntry] {
        var predictDataEntries = [ChartDataEntry]()
        var i = 0
        for p in predicts {
            predictDataEntries.append(ChartDataEntry(x: Double(i), y: p))
            i += 1
        }
        return predictDataEntries
    }
    
}
