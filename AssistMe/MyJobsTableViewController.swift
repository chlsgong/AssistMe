//
//  MyJobsTableViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/17/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class MyJobsTableViewController: UITableViewController {
    let fbMgr = FirebaseManager.manager
    var myJobs = [JobRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryMyJobs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryMyJobs() {
        fbMgr.queryMyJobs { myJob in
            self.myJobs.append(myJob)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myJobCell, for: indexPath) as! MyJobsTableViewCell

        cell.jobTitleLabel.text = myJobs[indexPath.row].jobTitle
        cell.jobOwnerLabel.text = myJobs[indexPath.row].job.displayName
        cell.partnerLabel.text = "Partner: \(myJobs[indexPath.row].partnerDisplayName)"
        cell.dateLabel.text = myJobs[indexPath.row].acceptDate
        if myJobs[indexPath.row].active == "true" {
            cell.activeImageView.image = UIImage(named: "ActiveState")
        }
        else {
            cell.activeImageView.image = UIImage(named: "InactiveState")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobListingVC = Utility.storyboard(forId: Identifier.jobListing).instantiateViewController(withIdentifier: Identifier.detailJobListing) as! JobListingViewController
        jobListingVC.jobRequest = myJobs[indexPath.row]
        jobListingVC.parentVC = "myJobs"
        
        self.navigationController?.pushViewController(jobListingVC, animated: true)
    }
}
