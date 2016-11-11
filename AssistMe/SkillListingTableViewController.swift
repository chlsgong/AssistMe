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
    var skillListings = [Skill]()
    let fbMgr = FirebaseManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        querySkills()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func querySkills() {
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
        
        cell.username.text = skillListings[indexPath.row].displayName
        cell.date.text = skillListings[indexPath.row].date
        cell.skillOne.text = skillListings[indexPath.row].skillOne
        cell.skillTwo.text = skillListings[indexPath.row].skillTwo
        cell.skillThree.text = skillListings[indexPath.row].skillThree
        cell.skillFour.text = skillListings[indexPath.row].skillFour

        return cell
    }
    
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
