//
//  AssetTableViewController.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class AssetTableViewController: UITableViewController {
    
    var stringURL = "http://eoss-setfin.appspot.com/csv?"
    
    var symbols = [Symbol]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            
            self.stringURL += String(arc4random_uniform(1000))
            if let url = URL(string: self.stringURL) {
                let text = try! String(contentsOf: url)
                var lines = text.components(separatedBy: "\n")
                lines.remove(at: 0)
                for line in lines {
                    if line.isEmpty {
                        continue
                    }
                    self.symbols.append(Symbol(line: line))
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return symbols.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stackAsset", for: indexPath) as! UIStackTableViewCell

        if indexPath.row < symbols.count {
            
            let set = symbols[indexPath.row]
            
            cell.symbolLabel.text = set.symbol
            cell.stackView.clear()
            cell.stackView.backgroundColor = UIColor.lightGray
            
            if let asset = set.values["Estimated Asset"] , let equity = set.values["Estimated Equity"], let net = set.values["Estimated Net"] {
                
                var ea,ne :Float
                
                if equity == 0 {
                    ne = 1
                } else {
                    ne = net/equity
                }
                
                if asset == 0 {
                    ea = 1
                } else {
                    ea = equity/asset
                }
                
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
            
        }

        return cell
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
