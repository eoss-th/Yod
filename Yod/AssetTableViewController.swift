//
//  AssetTableViewController.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class AssetTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleNet(_ sender: UIButton) {
        SET.toggleSort("N/E")
        self.tableView.reloadData()
    }
    @IBAction func toggleEquity(_ sender: UIButton) {
        SET.toggleSort("E/A")
        self.tableView.reloadData()
    }
    @IBAction func toggleAsset(_ sender: UIButton) {
        SET.toggleSort("Estimated Asset")
        self.tableView.reloadData()
    }
    @IBAction func toggleGrowth(_ sender: UIButton) {
        SET.toggleSort("E/A Growth %")
        self.tableView.reloadData()
    }
    @IBAction func togglePE(_ sender: UIButton) {
        SET.toggleSort("P/E")
        self.tableView.reloadData()
    }
    @IBAction func toggleLast(_ sender: UIButton) {
        SET.toggleSort("Last")
        self.tableView.reloadData()
    }
    @IBAction func togglePredict(_ sender: UIButton) {
        SET.toggleSort("Predict Chg %")
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SET.filters.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "headerAsset") as! UIHeaderTableViewCell
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            cell.growthButton.isHidden = false
            cell.peButton.isHidden = false
            cell.lastButton.isHidden = false
            cell.predictButton.isHidden = false
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            cell.growthButton.isHidden = true
            cell.peButton.isHidden = true
            cell.lastButton.isHidden = true
            cell.predictButton.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackAsset", for: indexPath) as! UIStackTableViewCell
        
        let filters = SET.filters
        
        if indexPath.row < filters.count {
            
            let set = filters[indexPath.row]
            
            cell.symbolLabel.text = set.symbol
            cell.stackView.clear()
            //cell.stackView.backgroundColor = UIColor(netHex:0xfbfbfa)
            
            let greenColor = UIColor(netHex:0x196319)
            let redColor = UIColor(netHex:0x880700)
            
            if let growth = set.values["E/A Growth %"] {
                cell.netGrowthLabel.text = String(growth)
                cell.netGrowthLabel.textColor = (growth >= 0) ? greenColor : redColor
            }
            
            if let pe = set.values["P/E"] {
                cell.peLabel.text = String(pe)
                cell.peLabel.textColor = (pe >= 0) ? greenColor : redColor
            }
            
            if let last = set.values["Last"] {
                cell.lastLabel.text = String(last)
                cell.lastLabel.textColor = (last >= 0) ? greenColor : redColor
            }
            
            if let predict = set.values["Predict Chg %"] {
                cell.predictLabel.text = String(predict)
                cell.predictLabel.textColor = (predict >= 0) ? greenColor : redColor
            }
            
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
            {
                cell.netGrowthLabel.isHidden = false
                cell.peLabel.isHidden = false
                cell.lastLabel.isHidden = false
                cell.predictLabel.isHidden = false
            }
            
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
            {
                cell.netGrowthLabel.isHidden = true
                cell.peLabel.isHidden = true
                cell.lastLabel.isHidden = true
                cell.predictLabel.isHidden = true
            }
            
            var ea = set.values["E/A"]!
            var ne = set.values["N/E"]!
            
            let eaColor:UIColor
            if ea > 0 {
                eaColor = UIColor(netHex:0xf2f2ef)
            } else {
                eaColor = UIColor(netHex:0xffebea)
                ea = ea * -1
            }
            
            let neColor:UIColor
            if ne > 0 {
                neColor = UIColor(netHex:0xb4ecb4)
            } else {
                neColor = UIColor(netHex:0xffb2ae)
                ne = ne * -1
            }
            
            if ne == 1 && ea == 1 {
                let _ = cell.stackView
                    .add(value: CGFloat(ea), percentChg: 0, color: eaColor)
                
            } else {
                
                let eaView:StackView
                
                if var eaGrowth = set.values["E/A Growth %"] {
                    
                    if eaGrowth > 100 {
                        eaGrowth = 100
                    }
                    
                    eaView = cell.stackView.add(value: CGFloat(ea), percentChg: eaGrowth, color: eaColor)
                    
                } else {
                    
                    eaView = cell.stackView.add(value: CGFloat(ea), percentChg: 0, color: eaColor)
                    
                }
                
                
                if var netGrowth = set.values["Net Growth %"] {
                    
                    if netGrowth > 100 {
                        netGrowth = 100
                    }
                    
                    let _ = eaView.add(value: CGFloat(ne), percentChg: netGrowth, color: neColor)
                    
                } else {
                    
                    let _ = eaView.add(value: CGFloat(ne), percentChg: 0, color: neColor)
                    
                }
            }
        }

        return cell
    }

    /*
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.tableView.reloadData()
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < SET.filters.count {
            DispatchQueue.global().async {
                let yahoo = Yahoo(symbol: SET.filters[indexPath.row].symbol!)
                DispatchQueue.main.async {
                    
                    self.tabBarController?.selectedIndex = 1
                    
                    let chartViewController = self.tabBarController?.viewControllers?[1] as! ChartViewController
                    
                    
                    chartViewController.chartLoadSymbol(description: "", yahoo: yahoo)
                }
            }
        }
    }
    
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
