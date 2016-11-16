//
//  SectorTableViewController.swift
//  Yod
//
//  Created by Enterprise Open Source Solution on 11/8/2559 BE.
//  Copyright © 2559 Enterprise Open Source Solution. All rights reserved.
//

import UIKit

class SectorTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    var filters = ["ROE > Avg", "Net Growth > Avg", "Equity Growth > Avg", "P/E < Avg"]
    
    var selectedFilters = [Int]()
    var searchText = String()
    var symbolFilters = [String]()
    var selectedIndustry:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return SET.industries.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filters.count
        }
        return SET.sections[SET.industries[section-1]]!.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerSearch") as! SearchBarTableViewCell
            cell.searchBar.text = self.searchText
            return cell
        }
        
        return super.tableView(tableView, viewForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50.0
        }
        return 44.0
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
            
            cell.textLabel?.text = SET.sections[SET.industries[indexPath.section-1]]?[indexPath.row]
            
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
            return nil
        }
        return SET.industries[section-1]
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
        
        self.applyFilters()
        
        let slideTabBarController = self.revealViewController().frontViewController as! SlideTabBarController
        slideTabBarController.reload()
        
        self.revealViewController().revealToggle(nil)
        self.tableView.reloadData()
    }
    
    func applyFilters() {
        
        SET.removeFilter()
        
        if selectedIndustry != nil {
            let industry = SET.industries[selectedIndustry!.section-1]
            let sector = SET.sections[industry]?[selectedIndustry!.row]
            SET.applyFilter(industry: industry, sector: sector!)
        }
        
        if selectedFilters.contains(0) {
            SET.applyFilter(field: "ROE", operand: >, value: SET.roeMean)
        }
        
        if selectedFilters.contains(1) {
            SET.applyFilter(field: "Net Growth %", operand: >, value: SET.netGrowthMean)
        }
        
        if selectedFilters.contains(2) {
            SET.applyFilter(field: "E/A Growth %", operand: >, value: SET.growthMean)
        }
        
        if selectedFilters.contains(3) {
            SET.applyFilter(field: "P/E", operand: <, value: SET.peMean)
        }
        
        if !self.symbolFilters.isEmpty {
            SET.applyFilter(symbols: self.symbolFilters)
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.revealViewController().revealToggle(nil)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let symbols = self.searchText.replacingOccurrences(of: " &", with: "-&").replacingOccurrences(of: "& ", with: "&-")
        self.symbolFilters = symbols.components(separatedBy: " ")
        
        if let sAndJIndex = self.symbolFilters.index(of: "S-&") {
            self.symbolFilters[sAndJIndex] = "S &"
        }
        
        if let sAndJIndex = self.symbolFilters.index(of: "S-&-J") {
            self.symbolFilters[sAndJIndex] = "S & J"
        }
        
        self.applyFilters()
        
        let slideTabBarController = self.revealViewController().frontViewController as! SlideTabBarController
        slideTabBarController.reload()
    }

}
