//
//  AssetTableViewController.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AssetTableViewController: UITableViewController {
    
    var buttonFieldMap = [String:String]()
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFieldMap["Net Growth"] = "Net Growth %"
        buttonFieldMap["Equity Growth"] = "E/A Growth %"
        buttonFieldMap["P/E"] = "P/E"
        buttonFieldMap["Last"] = "Last"
        buttonFieldMap["Predict"] = "Predict MA"
        buttonFieldMap["Predict %"] = "Predict Chg %"
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        createAndLoadInterstitial()
    }
    
    func rotated() {
        createAndLoadInterstitial()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2408994207086484/2420281853")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        //request.testDevices = [ kGADSimulatorID, "83653C28-0ACD-4919-BF41-B66F95F7B019" ]
        interstitial.load(request)
    }
    
    func sort (_ button:UIButton) {
        let buttonText = button.titleLabel?.text
        let field = buttonFieldMap[buttonText!]!
        SET.toggleSort(field)
        self.tableView.reloadData()
    }
    
    @IBAction func toggleSlide(_ sender: UIButton) {
        self.revealViewController().revealToggle(nil)
    }
    @IBAction func toggleNet(_ sender: UIButton) {
        sort(sender)
    }
    @IBAction func toggleGrowth(_ sender: UIButton) {
        sort(sender)
    }
    @IBAction func togglePE(_ sender: UIButton) {
        sort(sender)
    }
    @IBAction func toggleLast(_ sender: UIButton) {
        sort(sender)
    }
    @IBAction func togglePredict(_ sender: UIButton) {
        sort(sender)
    }
    @IBAction func togglePredictChg(_ sender: UIButton) {
        sort(sender)
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
        
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            
            cell.pebutton.isHidden = false
            cell.lastButton.isHidden = false
            cell.predictButton.isHidden = false
            cell.predictChgButton.isHidden = false
            
        } else if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            cell.pebutton.isHidden = true
            cell.lastButton.isHidden = true
            cell.predictButton.isHidden = true
            cell.predictChgButton.isHidden = true
        }
        
        if let val =  SET.toggles[buttonFieldMap[(cell.netButton.titleLabel?.text)!]!] {
            
            if val {
                cell.netButton.backgroundColor = UIColor(netHex:0xb4ecb4)
            } else {
                cell.netButton.backgroundColor = UIColor(netHex:0xffb2ae)
            }
            
        } else {
            cell.netButton.backgroundColor = UIColor.white
        }

        if let val =  SET.toggles[buttonFieldMap[(cell.growthButton.titleLabel?.text)!]!] {
            
            if val {
                cell.growthButton.backgroundColor = UIColor(netHex:0xdee8eb)
            } else {
                cell.growthButton.backgroundColor = UIColor(netHex:0x7ea4b3)
            }
            
        } else {
            cell.growthButton.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:50))
        view.backgroundColor = UIColor.white
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackAsset", for: indexPath) as! UIStackTableViewCell
        
        let filters = SET.filters
        
        if indexPath.row < filters.count {
            
            let set = filters[indexPath.row]
            
            cell.symbolLabel.text = set.symbol
            cell.stackView.clear()
            cell.stackView.backgroundColor = UIColor.white
            
            let greenColor = UIColor(netHex:0x196319)
            let redColor = UIColor(netHex:0x880700)
            
            if let pe = set.values["P/E"] {
                if pe == Float.infinity {
                    cell.peLabel.text = "-"
                    cell.peLabel.textColor = UIColor.lightGray
                } else {
                    cell.peLabel.text = String(pe)
                    cell.peLabel.textColor = (pe >= 0) ? greenColor : redColor
                }
            }
            
            let lastPrice:Float
            
            if let last = set.values["Last"] {
                cell.lastLabel.text = String(last)
                cell.lastLabel.textColor = (last >= 0) ? greenColor : redColor
                lastPrice = last
            } else {
                lastPrice = 0
            }
            
            if let predict = set.values["Predict MA"] {
                cell.predictLabel.text = String(predict)
                cell.predictLabel.textColor = (predict >= lastPrice) ? greenColor : redColor
            }
            
            if let predictChg = set.values["Predict Chg %"] {
                cell.predictChgLabel.text = String(predictChg)
                cell.predictChgLabel.textColor = (predictChg >= 0) ? greenColor : redColor
            }
            
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                cell.peLabel.isHidden = false
                cell.lastLabel.isHidden = false
                cell.predictLabel.isHidden = false
                cell.predictChgLabel.isHidden = false
            } else if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                cell.peLabel.isHidden = true
                cell.lastLabel.isHidden = true
                cell.predictLabel.isHidden = true
                cell.predictChgLabel.isHidden = true
            }
            
            let ga = set.values["G/A"]!
            var eg = set.values["E/G"]!
            var nge = set.values["NG/E"]!
            var nng = set.values["N/NG"]!
            
            let gaColor:UIColor
            
            if let growth = set.values["E/A Growth %"] {
                if growth > 0 {
                    gaColor = UIColor(netHex:0xdee8eb)
                } else {
                    gaColor = UIColor(netHex:0x7ea4b3)
                }
            } else {
                gaColor = UIColor.white
            }
            
            let egColor:UIColor
            if eg > 0 {
                egColor = UIColor.white
            } else {
                egColor = UIColor(netHex:0xffebea)
                eg = eg * -1
            }
            
            let ngeColor:UIColor
            if nge > 0 {
                ngeColor = UIColor(netHex:0xb4ecb4)
            } else {
                ngeColor = UIColor(netHex:0xffb2ae)
                nge = nge * -1
            }
            
            let nngColor:UIColor
            if nng > 0 {
                nngColor = UIColor.white
            } else {
                nngColor = UIColor(netHex:0xff6961)
                nng = nng * -1
            }
            
            if nge == 1 && eg == 1 {
                let _ = cell.stackView
                    .add(value: CGFloat(eg), color: egColor)
                
            } else {
                
                let _ = cell.stackView
                        .add(value: CGFloat(ga), color: gaColor)
                        .add(value: CGFloat(eg), color: egColor)
                        .add(value: CGFloat(nge), color: ngeColor)
                        .add(value: CGFloat(nng), color: nngColor)
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
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
            
            self.tabBarController?.selectedIndex = 1
            let chartViewController = self.tabBarController?.viewControllers?[1] as! ChartViewController
            
            let set = SET.filters[indexPath.row]
            chartViewController.reset(set: set)
            
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
