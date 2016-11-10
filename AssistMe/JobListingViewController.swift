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
        
        usernameLabel.text = displayName
        dateLabel.text = date
        descriptionTextView.text = jobDescription
        teamworkRatingLabel.text = teamworkRating
        skillRatingLabel.text = skillRating
    }

    @IBAction func messageButtonTapped(_ sender: AnyObject) {
    }
    
}
