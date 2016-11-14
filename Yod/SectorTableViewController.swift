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
    
    var industries = [String]()
    var sections = [String:[String]]()
    var selectedPath:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        return industries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[industries[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "section", for: indexPath)

        cell.textLabel?.text = sections[industries[indexPath.section]]?[indexPath.row]
        
        if (selectedPath==indexPath) {
            cell.backgroundColor = UIColor(netHex: 0xd3e0e5)
            cell.textLabel?.backgroundColor = UIColor(netHex: 0xd3e0e5)
        } else {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // fixed font style. use custom view (UILabel) if you want something different
        return industries[section]
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
        
        if selectedPath != nil && selectedPath?.section == indexPath.section && selectedPath?.row == indexPath.row {
            
            SET.removeFilter()
            selectedPath = nil
            
        } else {
            let industry = industries[indexPath.section]
            let sector = sections[industry]?[indexPath.row]
            
            SET.applyFilter(industry: industry, sector: sector!)
            selectedPath = indexPath
            
        }
        
        self.tableView.reloadData()
        
        let slideTabBarController = self.revealViewController().frontViewController as! SlideTabBarController
        slideTabBarController.reload()
        
        self.revealViewController().revealToggle(nil)
    }
    

}
