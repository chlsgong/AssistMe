//
//  MyJobListingsTableViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class MyJobListingsTableViewController: UITableViewController {
    var alert: UIAlertController!
    
    let fbMgr = FirebaseManager.manager
    var myJobs = [Job]()
    var receiverUID: String!
    var receiverDisplayName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveMyJobs()
        
        alert = setupAlertView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMyJobs() {
        fbMgr.queryJobListings(forUID: fbMgr.currentUser!.uid) { job in
            self.myJobs.append(job)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Alert view setup
    
    func setupAlertView() -> UIAlertController {
        let alert = UIAlertController(title: "Request Sent!", message: nil, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(OKAction)
        
        return alert
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myJobListingsCell, for: indexPath)

        cell.textLabel?.text = myJobs[indexPath.row].title
        cell.detailTextLabel?.text = myJobs[indexPath.row].date
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = Date().toStringFromDefaultDate()
        fbMgr.sendRequest(toUID: receiverUID, partnerDisplayName: receiverDisplayName, job: myJobs[indexPath.row], requestDate: date)
        
        self.present(alert, animated: true, completion: nil)
    }

}
