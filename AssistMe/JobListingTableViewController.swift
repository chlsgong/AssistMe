//
//  JobListingTableViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Firebase

class JobListingTableViewController: UITableViewController {
    let fbMgr = FirebaseManager.manager
    
    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        queryJobs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryJobs() {
        fbMgr.queryJobListings { job in
            self.jobs.append(job)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.showJob {
            let cell = sender as! JobListingTableViewCell
            let destination = segue.destination as! JobListingViewController
            let job = jobs[self.tableView.indexPath(for: cell)!.row]
            
            destination.uid = job.uid
            destination.jobTitle = job.title
            destination.displayName = job.displayName
            destination.jobDescription = job.description
            destination.date = job.date
            destination.teamworkRating = job.rating.teamwork
            destination.skillRating = job.rating.skill
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.jobListingCell, for: indexPath) as! JobListingTableViewCell
        
        let job = jobs[indexPath.row]
        cell.usernameLabel.text = job.displayName
        cell.dateLabel.text = job.date
        cell.jobTitleLabel.text = job.title
        cell.descriptionTextView.text = job.description
        cell.ratingLabel.text = job.rating.average
        
        return cell
    }
 
}
