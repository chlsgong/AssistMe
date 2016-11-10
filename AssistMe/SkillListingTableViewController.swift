//
//  SkillListingTableViewController.swift
//  AssistMe
//
//  Created by Bhavish on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Firebase

class SkillListingTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var skillListings = [SkillListing]()
    let fbMgr = FirebaseManager.manager
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryJobs()
//            self.tableView.insertRows(at: [IndexPath(row: self.skillListings.count-1, section:0)], with: UITableViewRowAnimation.automatic)
        }
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func queryJobs() {
        fbMgr.querySkillListings { skill in
            self.skillListings.append(skill)
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return skillListings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillListingCell", for: indexPath) as! SkillListingTableViewCell
        
        cell.username.text = skillListings[indexPath.row].username
        cell.date.text = skillListings[indexPath.row].date
        cell.skillOne.text = skillListings[indexPath.row].skillOne
        cell.skillTwo.text = skillListings[indexPath.row].skillTwo
        cell.skillThree.text = skillListings[indexPath.row].skillThree
        cell.skillFour.text = skillListings[indexPath.row].skillFour

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "skillListingDetails") {
            let viewController:SkillListingViewController = (segue.destination as? SkillListingViewController)!
            let indexPath = self.tableView.indexPathForSelectedRow!
            viewController.listing = skillListings[indexPath.row]
        }

    }
 

}
