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
    
    var yahoo:Yahoo?
    
    var set:SET?
    
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
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
        
        rotated()
    }
    
    func waiting() {        
        combinedChartView.data = nil
        combinedChartView.noDataText = "Loading..."
        combinedChartView.setNeedsDisplay()
    }
    
    @IBAction func loadWeek(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 0)
        }
    }
    @IBAction func loadMonth(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 1)
        }
    }
    @IBAction func load3Months(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 2)
        }
    }
    @IBAction func load6Months(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 3)
        }
    }
    @IBAction func loadYear(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 4)
        }
    }
    @IBAction func load3Years(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 5)
        }
    }
    @IBAction func load6Years(_ sender: UIBarButtonItem) {
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 6)
        }
    }
    
    internal func load(description:String, yahoo:Yahoo, daysIndex:Int=0) {
        
        self.yahoo = yahoo
        self.daysIndex = daysIndex
        
        combinedChartView.chartDescription?.text = description
        
        let closeDataSet = LineChartDataSet (values: createCloseDataEntries(), label: "Close")
        closeDataSet.circleRadius = 0
        closeDataSet.axisDependency = combinedChartView.rightAxis.axisDependency
        closeDataSet.setColor(NSUIColor.gray)
        
        let ma5DataSet = LineChartDataSet (values: createEMA5DataEntries(), label: "EMA5")
        ma5DataSet.circleRadius = 0
        ma5DataSet.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma5DataSet.valueTextColor = NSUIColor.white
        //ma5DataSet.highlightColor = NSUIColor.white
        ma5DataSet.setColor(NSUIColor.green)
        
        let ma20DataSet = LineChartDataSet (values: createEMA20DataEntries(), label: "EMA20")
        ma20DataSet.circleRadius = 0
        ma20DataSet.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma20DataSet.valueTextColor = NSUIColor.white
        //ma20DataSet.highlightColor = NSUIColor.white
        ma20DataSet.setColor(NSUIColor.cyan)
        
        let ma80DataSet = LineChartDataSet (values: createEMA80DataEntries(), label: "EMA80")
        ma80DataSet.circleRadius = 0
        ma80DataSet.axisDependency = combinedChartView.rightAxis.axisDependency
        //ma80DataSet.valueTextColor = NSUIColor.white
        //ma80DataSet.highlightColor = NSUIColor.white
        ma80DataSet.setColor(NSUIColor.orange)
        
        let lineData = LineChartData()
        //lineData.addDataSet(closeDataSet)
        lineData.addDataSet(ma5DataSet)
        lineData.addDataSet(ma20DataSet)
        lineData.addDataSet(ma80DataSet)
        
        let candleDataSet = CandleChartDataSet (values: createHiLoDataEntries(), label: "Candle")
        candleDataSet.axisDependency = combinedChartView.rightAxis.axisDependency
        //candleDataSet.valueTextColor = NSUIColor.white
        //candleDataSet.highlightColor = NSUIColor.white
        candleDataSet.increasingFilled = true
        candleDataSet.setColor(UIColor(netHex:0xb4ecb4))
        candleDataSet.increasingColor = UIColor(netHex:0xb4ecb4)
        candleDataSet.decreasingColor = UIColor(netHex:0xffb2ae)
        
        let candleData = CandleChartData()
        candleData.addDataSet(candleDataSet)
        
        let volumeDataSet = BarChartDataSet (values: createVolumeDataEntries(), label: "Volume")
        //volumeDataSet?.valueTextColor = NSUIColor.white
        //volumeDataSet?.highlightColor = NSUIColor.white
        volumeDataSet.setColor(UIColor(netHex:0xf2f2ef))
        volumeDataSet.axisDependency = combinedChartView.leftAxis.axisDependency
        
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
        
        combinedChartView.leftAxis.axisMinimum = volumeDataSet.yMin
        combinedChartView.leftAxis.axisMaximum = volumeDataSet.yMax * 3
        combinedChartView.leftAxis.spaceTop = 20
        //combinedChartView.leftAxis.enabled = false
        
        combinedChartView.rightAxis.axisMinimum = closeDataSet.yMin * 0.95
        combinedChartView.rightAxis.axisMaximum = closeDataSet.yMax * 1.05
        combinedChartView.rightAxis.spaceTop = 20
        
        combinedChartView.moveViewToX(Double(lineData.dataSets.count - 1))
        
        combinedChartView.setNeedsDisplay()
    }
    
    internal func load(description:String, set:SET) {
        
        self.set = set
        
        combinedChartView.chartDescription?.text = description
        
        let assetDataSet = BarChartDataSet (values: createAssetDataEntries(), label: "Asset")
        assetDataSet.setColor(NSUIColor.cyan)
        
        let liabilitiesDataSet = BarChartDataSet (values: createLiabilitiesDataEntries(), label: "Liabilities")
        liabilitiesDataSet.setColor(NSUIColor.lightGray)
        
        let equityDataSet = BarChartDataSet (values: createEquityDataEntries(), label: "Equity")
        equityDataSet.setColor(UIColor.green)
        
        let paidUpCapital = BarChartDataSet (values: createPaidUpCapitalDataEntries(), label: "Paidup Capital")
        paidUpCapital.setColor(UIColor.blue)
        
        let barData = BarChartData()
        barData.addDataSet(assetDataSet)
        barData.addDataSet(liabilitiesDataSet)
        barData.addDataSet(equityDataSet)
        barData.addDataSet(paidUpCapital)
        
        combinedChartView.xAxis.valueFormatter = XValueFormatter(values: createFSDates())
        
        let data = CombinedChartData()
        data.barData = barData
        
        //Reset View
        combinedChartView.data = data
        
        combinedChartView.fitScreen()
        combinedChartView.moveViewToX(Double(assetDataSet.entryCount-1))
        combinedChartView.setNeedsDisplay()
    }
    
    func rotated() {
        
        if toolBar != nil {
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
            {
                toolBar.isHidden = false
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
            {
                toolBar.isHidden = true
            }
        }
        
        if let yahoo = self.yahoo {
            load(description: yahoo.symbol, yahoo: yahoo, daysIndex: 0)
        }
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
        
        if (daysIndex==0) {
            
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                dateFormatter.dateFormat = "dd"
            } else {
                dateFormatter.dateFormat = "EEEE dd"
            }
            
        } else if (daysIndex<3) {
            
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
    
    func createAssetDataEntries () -> [ChartDataEntry] {
        var dataEntries = [ChartDataEntry]()
        var i = 0
        let histories = set?.histories
        for h in histories! {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(h.assets)))
            i += 1
        }
        
        return dataEntries
    }
    
    func createLiabilitiesDataEntries () -> [ChartDataEntry] {
        var dataEntries = [ChartDataEntry]()
        var i = 0
        let histories = set?.histories
        for h in histories! {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(h.liabilities)))
            i += 1
        }
        
        return dataEntries
    }
    
    func createEquityDataEntries () -> [ChartDataEntry] {
        var dataEntries = [ChartDataEntry]()
        var i = 0
        let histories = set?.histories
        for h in histories! {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(h.equity)))
            i += 1
        }
        
        return dataEntries
    }
    
    func createPaidUpCapitalDataEntries () -> [ChartDataEntry] {
        var dataEntries = [ChartDataEntry]()
        var i = 0
        let histories = set?.histories
        for h in histories! {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: Double(h.paidUpCapital)))
            i += 1
        }
        
        return dataEntries
    }
    
    
    func createFSDates () -> [String] {
        var dates = [String]()
        let histories = set?.histories
        for h in histories! {
            dates.append(h.asOfDate)
        }
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
