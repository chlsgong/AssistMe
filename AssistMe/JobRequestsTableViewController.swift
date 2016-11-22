//
//  JobRequestsTableViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/17/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class JobRequestsTableViewController: UITableViewController {
    let fbMgr = FirebaseManager.manager
    var jobRequests = [JobRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryJobRequests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryJobRequests() {
        fbMgr.queryRequests { jobRequest in
            self.jobRequests.append(jobRequest)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.jobRequestCell, for: indexPath) as! JobRequestTableViewCell

        cell.jobTitleLabel.text = jobRequests[indexPath.row].jobTitle
        cell.displayNameLabel.text = jobRequests[indexPath.row].displayName
        cell.requestDateLabel.text = jobRequests[indexPath.row].requestDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobListingVC = Utility.storyboard(forId: Identifier.jobListing).instantiateViewController(withIdentifier: Identifier.detailJobListing) as! JobListingViewController
        jobListingVC.jobRequest = jobRequests[indexPath.row]
        jobListingVC.parentVC = "jobRequests"
        
        self.navigationController?.pushViewController(jobListingVC, animated: true)
    }

}
