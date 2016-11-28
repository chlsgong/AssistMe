//
//  JobListingViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/9/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class JobListingViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var teamworkRatingLabel: UILabel!
    @IBOutlet weak var skillRatingLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeJobButton: UIButton!
    
    let fbMgr = FirebaseManager.manager
    var jobRequest: JobRequest?
    var job: Job!
    var parentVC: String!
    
    var uid: String!
    var jobTitle: String!
    var displayName: String!
    var date: String!
    var jobDescription: String!
    var teamworkRating: String!
    var skillRating: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        extractJobProperties()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func extractJobProperties() {
        if jobRequest != nil {
            job = jobRequest!.job
        }
        uid = job.uid
        jobTitle = job.title
        displayName = job.displayName
        jobDescription = job.description
        date = job.date
        teamworkRating = job.rating.teamwork
        skillRating = job.rating.skill
    }
    
    func setupUI() {
        self.navigationItem.title = jobTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        usernameLabel.text = displayName
        dateLabel.text = date
        descriptionTextView.text = jobDescription
        teamworkRatingLabel.text = teamworkRating
        skillRatingLabel.text = skillRating
        
        if uid == fbMgr.currentUser!.uid {
            messageButton.isHidden = true
        }
        
        if parentVC == "jobListing" {
            acceptButton.isHidden = true
            closeJobButton.isHidden = true
        }
        else if parentVC == "myJobs" {
            messageButton.isHidden = true
            acceptButton.isHidden = true
            if !isJobOwner() {
                closeJobButton.isHidden = true
            }
        }
        else {
            messageButton.isHidden = true
            closeJobButton.isHidden = true
        }
    }
    
    func isJobOwner() -> Bool {
        return fbMgr.currentUser!.uid == job.uid
    }

    @IBAction func messageButtonTapped(_ sender: AnyObject) {
        let chatVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: Identifier.chat) as! ChatViewController
        chatVC.receiverId = uid
        chatVC.receiverDisplayName = displayName
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
        acceptButton.isEnabled = false
        acceptButton.setTitle("Accepted", for: .disabled)
        acceptButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        let date = Date().toStringFromDefaultDate()
        jobRequest!.acceptDate = date
        jobRequest!.active = "true"
        
        fbMgr.acceptJobRequest(jobRequest: jobRequest!)
    }
    
    @IBAction func closeJobTapped(_ sender: AnyObject) {
        closeJobButton.isEnabled = false
        closeJobButton.setTitle("Job Closed", for: .disabled)
        closeJobButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        jobRequest!.active = "false"
        
        fbMgr.closeMyJob(jobRequest: jobRequest!)
    }
}
