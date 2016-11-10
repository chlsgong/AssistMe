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
    
    let fbMgr = FirebaseManager.manager
    
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
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationItem.title = jobTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        usernameLabel.text = displayName
        dateLabel.text = date
        descriptionTextView.text = jobDescription
        teamworkRatingLabel.text = teamworkRating
        skillRatingLabel.text = skillRating
        
        if uid == fbMgr.currentUser?.uid {
            messageButton.isHidden = true
        }
    }

    @IBAction func messageButtonTapped(_ sender: AnyObject) {
        let chatVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: Identifier.chat) as! ChatViewController
        chatVC.receiverId = uid
        chatVC.receiverDisplayName = displayName
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
