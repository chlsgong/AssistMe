//
//  ProfileViewController.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 10/23/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    let fbMgr = FirebaseManager.manager
    let user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var listingsTableView: UITableView!
    @IBOutlet weak var segmentedTableViewController: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var jobs: [Job] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadInfo()
        reloadData()
    }
    
    private func reloadInfo() {
        // Not sure if this works; Supposed to make the settings button look like a little gear thing
        self.settingsButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }
        
        ref = FIRDatabase.database().reference()
        
        if let userID = user?.uid {
            usernameLabel.text = userID
        } else {
            usernameLabel.text = ""
        }
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("profile").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let description = value?["description"] as? String ?? ""
            let skills = value?["skills"] as? String ?? ""
            
            if description != "" {
                self.descriptionLabel.text = description
            } else {
                self.descriptionLabel.text = ""
            }
            
            if skills != "" {
                self.skillsLabel.text = skills
            } else {
                self.skillsLabel.text = ""
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        usernameLabel.text = user?.displayName
        // profileImage.image = user?.photoURL
    }
    
    fileprivate func reloadData() {
        fbMgr.queryJobListings(forUID: user!.uid) { job in
            self.jobs = [job]
            self.listingsTableView.reloadData()
        }
    }
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath)
        
        cell.textLabel?.text = jobs[indexPath.row].title
        cell.detailTextLabel?.text = jobs[indexPath.row].date
        
        return cell
    }
}


extension ProfileViewController: UITableViewDelegate {
    
}
