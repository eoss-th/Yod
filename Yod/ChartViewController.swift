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
    
    let DAYS = [7, 30, 180, 365, 365*2, 365*3, 365*4]
    
    var daysIndex = 0
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    var yahoo:Yahoo?
    
    var candleDataSet:CandleChartDataSet?
    
    var closeDataSet:LineChartDataSet?
    
    var ma5DataSet:LineChartDataSet?
    
    var ma20DataSet:LineChartDataSet?
    
    var ma80DataSet:LineChartDataSet?
    
    var volumeDataSet:BarChartDataSet?
    
    var predictDataSet:LineChartDataSet?
    
    override func viewDidLoad() {
        
        combinedChartView.noDataText = "Please select a symbol"
        
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
        combinedChartView.rightAxis.drawGridLinesEnabled = false
        
        combinedChartView.leftAxis.zeroLineColor = UIColor.white
        combinedChartView.leftAxis.gridColor = UIColor.white
        combinedChartView.leftAxis.axisLineColor = UIColor.white
        combinedChartView.leftAxis.labelTextColor = UIColor.white
        combinedChartView.leftAxis.drawGridLinesEnabled = false
        
        combinedChartView.xAxis.gridColor = UIColor.white
        combinedChartView.xAxis.labelTextColor = UIColor.white
        combinedChartView.xAxis.axisLineColor = UIColor.white
        combinedChartView.xAxis.drawGridLinesEnabled = false
        combinedChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
    }
    
    @IBAction func loadWeek(sender: UIButton) {
        daysIndex = 0
    }
    @IBAction func loadMonth(sender: UIButton) {
        daysIndex = 1
    }
    @IBAction func load6Months(sender: UIButton) {
        daysIndex = 2
    }
    @IBAction func loadYear(sender: UIButton) {
        daysIndex = 3
    }
    @IBAction func load2Years(sender: UIButton) {
        daysIndex = 4
    }
    @IBAction func load3Years(sender: UIButton) {
        daysIndex = 6
    }
    @IBAction func load4Years(sender: UIButton) {
        daysIndex = 5
    }
    internal func chartLoadSymbol(description:String, yahoo:Yahoo, daysIndex:Int=0) {
        
        self.yahoo = yahoo
        self.daysIndex = daysIndex
        
        combinedChartView.chartDescription?.text = description
        
        closeDataSet = LineChartDataSet (values: createCloseDataEntries(), label: "Close")
        closeDataSet!.circleRadius = 0
        closeDataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        closeDataSet!.setColor(NSUIColor.black)
        
        ma5DataSet = LineChartDataSet (values: createEMA5DataEntries(), label: "EMA5")
        ma5DataSet!.circleRadius = 0
        ma5DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        ma5DataSet?.valueTextColor = NSUIColor.white
        ma5DataSet?.highlightColor = NSUIColor.white
        ma5DataSet!.setColor(NSUIColor.white)
        
        ma20DataSet = LineChartDataSet (values: createEMA20DataEntries(), label: "EMA20")
        ma20DataSet!.circleRadius = 0
        ma20DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        ma20DataSet?.valueTextColor = NSUIColor.white
        ma20DataSet?.highlightColor = NSUIColor.white
        ma20DataSet!.setColor(NSUIColor.cyan)
        
        ma80DataSet = LineChartDataSet (values: createEMA80DataEntries(), label: "EMA80")
        ma80DataSet!.circleRadius = 0
        ma80DataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        ma80DataSet?.valueTextColor = NSUIColor.white
        ma80DataSet?.highlightColor = NSUIColor.white
        ma80DataSet!.setColor(NSUIColor.lightGray)
        
        let lineData = LineChartData()
        //lineData.addDataSet(closeDataSet)
        lineData.addDataSet(ma5DataSet)
        lineData.addDataSet(ma20DataSet)
        lineData.addDataSet(ma80DataSet)
        
        candleDataSet = CandleChartDataSet (values: createHiLoDataEntries(), label: "Candle")
        candleDataSet?.axisDependency = combinedChartView.rightAxis.axisDependency
        candleDataSet?.valueTextColor = NSUIColor.white
        candleDataSet?.highlightColor = NSUIColor.white
        candleDataSet?.increasingFilled = true
        candleDataSet?.setColor(NSUIColor.white)
        candleDataSet?.increasingColor = NSUIColor.green
        candleDataSet?.decreasingColor = NSUIColor.red
        
        let candleData = CandleChartData()
        candleData.addDataSet(candleDataSet)
        
        volumeDataSet = BarChartDataSet (values: createVolumeDataEntries(), label: "Volume")
        volumeDataSet?.valueTextColor = NSUIColor.white
        volumeDataSet?.highlightColor = NSUIColor.white
        volumeDataSet?.setColor(NSUIColor.darkGray)
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
        combinedChartView.leftAxis.enabled = false
        
        combinedChartView.rightAxis.axisMinimum = (closeDataSet?.yMin)! * 0.95
        combinedChartView.rightAxis.axisMaximum = (closeDataSet?.yMax)! * 1.05
        combinedChartView.rightAxis.spaceTop = 20
        
        combinedChartView.moveViewToX(Double(lineData.dataSets.count - 1))
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
        var dates = [String]()
        var i = 0
        let histories = yahoo?.histories
        if limit > histories!.count {
            limit = histories!.count
        }
        for j in histories!.count-limit..<histories!.count {
            dates.append(histories![j].date)
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
