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
import AlamofireImage

class ProfileViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    let fbMgr = FirebaseManager.manager
    let user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var listingsTableView: UITableView!
    @IBOutlet weak var segmentedTableViewController: UISegmentedControl!
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet weak var skillRatingLabel: UILabel!
    @IBOutlet weak var teamworkRatingLabel: UILabel!
    
    var jobs: [Job] = []
    var skills: [Skill] = []
    
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
        
        ref.child("profile").child(userID!).child("rating").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let skillRating = value?["skillRating"] as? String ?? ""
            let teamWorkRating = value?["teamworkRating"] as? String ?? ""
            
            self.skillRatingLabel.text = skillRating
            self.teamworkRatingLabel.text = teamWorkRating
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("profile").child(userID!).child("skills").observeSingleEvent(of: .value, with: { (snapshot) in
            if let skillsDictionary = snapshot.value as? [String : String] {
                var stringSkill = ""
                for (_, value) in skillsDictionary {
                    stringSkill.append(value)
                    stringSkill.append(", ")
                }
                stringSkill = stringSkill.substring(to: stringSkill.index(before: stringSkill.index(before: stringSkill.endIndex)))
                self.skillsLabel.text = stringSkill
            } else {
                self.skillsLabel.text = ""
            }
        }) { (error) in
            print(error.localizedDescription)
        }
            
        usernameLabel.text = user?.displayName
        
        if let url = user?.photoURL {
            self.profileImage.af_setImage(withURL: url)
        }
    }
    
    fileprivate func reloadData() {
        if segmentedTableViewController.selectedSegmentIndex == 0 {
            self.jobs.removeAll()
            self.listingsTableView.reloadData()
            fbMgr.queryJobListings(forUID: user!.uid) { job in
                self.jobs.append(job)
                self.listingsTableView.reloadData()
            }
        } else {
            self.skills.removeAll()
            self.listingsTableView.reloadData()
            fbMgr.querySkillsListings(forUID: user!.uid) { skill in
                self.skills.append(skill)
                self.listingsTableView.reloadData()
            }
        }
    }

    @IBAction func listingTypeSegDidChange(_ sender: AnyObject) {
        reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedTableViewController.selectedSegmentIndex == 0 {
            return jobs.count
        } else {
            return skills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath)
        
        if segmentedTableViewController.selectedSegmentIndex == 0 {
            cell.textLabel?.text = jobs[indexPath.row].title
            cell.detailTextLabel?.text = jobs[indexPath.row].date
        } else {
            cell.textLabel?.text = skills[indexPath.row].skillOne
            cell.detailTextLabel?.text = skills[indexPath.row].date
        }
        
        
        return cell
    }
}


extension ProfileViewController: UITableViewDelegate {
    
}
