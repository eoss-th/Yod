//
//  SectorTableViewController.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class SectorTableViewController: UITableViewController {
    
    let stringURL = "http://eoss-setfin.appspot.com/SETIndexServlet"
    
    var filters = ["ROE > Avg", "Growth > Avg", "P/E < Avg"]
    var industries = [String]()
    var sections = [String:[String]]()
    
    var selectedFilters = [Int]()
    var selectedIndustry:IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            
            if let url = URL(string: self.stringURL) {
                let text = try! String(contentsOf: url)
                let lines = text.components(separatedBy: "\n")
                for line in lines {
                    if line.isEmpty {
                        continue
                    }
                    var names = line.components(separatedBy: ",")
                    let sector = names[0]
                    names.remove(at: 0)
                    self.sections[sector] = names.sorted()
                }
                
                self.industries = self.sections.keys.sorted()
                
            }
            
            self.industries.remove(at: 0)
            
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
        return industries.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filters.count
        }
        return sections[industries[section-1]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section", for: indexPath)
        
        if indexPath.section == 0 {
            
            cell.textLabel?.text = filters [indexPath.row]
            
            if selectedFilters.contains(indexPath.row) {
                cell.backgroundColor = UIColor(netHex: 0xd3e0e5)
                cell.textLabel?.backgroundColor = UIColor(netHex: 0xd3e0e5)
            } else {
                cell.backgroundColor = UIColor.white
                cell.textLabel?.backgroundColor = UIColor.white
            }
            
        } else {
            
            cell.textLabel?.text = sections[industries[indexPath.section-1]]?[indexPath.row]
            
            if (selectedIndustry==indexPath) {
                cell.backgroundColor = UIColor(netHex: 0xd3e0e5)
                cell.textLabel?.backgroundColor = UIColor(netHex: 0xd3e0e5)
            } else {
                cell.backgroundColor = UIColor.white
                cell.textLabel?.backgroundColor = UIColor.white
            }
            
        }

        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // fixed font style. use custom view (UILabel) if you want something different
        if section == 0 {
            return "Filters"
        }
        return industries[section-1]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if selectedFilters.contains(indexPath.row) {
                
                selectedFilters.remove(at: selectedFilters.index(of: indexPath.row)!)
                
            } else {
                
                selectedFilters.append(indexPath.row)
                
            }
            
        } else if selectedIndustry == indexPath {
            
            selectedIndustry = nil
            
        } else {
            
            selectedIndustry = indexPath
            
        }
        
        SET.removeFilter()
        
        if selectedIndustry != nil {
            let industry = industries[selectedIndustry!.section-1]
            let sector = sections[industry]?[selectedIndustry!.row]
            SET.applyFilter(industry: industry, sector: sector!)
        }
        
        if selectedFilters.contains(0) {
            SET.applyFilter(field: "N/E", operand: >, value: SET.neMean)
        }
        
        if selectedFilters.contains(1) {
            SET.applyFilter(field: "E/A Growth %", operand: >, value: SET.growthMean)
        }
        
        if selectedFilters.contains(2) {
            SET.applyFilter(field: "P/E", operand: <, value: SET.peMean)
        }
        
        self.tableView.reloadData()
        
        let slideTabBarController = self.revealViewController().frontViewController as! SlideTabBarController
        slideTabBarController.reload()
        
        self.revealViewController().revealToggle(nil)
    }
    

}
