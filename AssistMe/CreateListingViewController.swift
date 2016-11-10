//
//  CreateListingViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/9/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class CreateListingViewController: UIViewController {
    @IBOutlet weak var listingTypeSegControl: UISegmentedControl!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var skillOneTextField: UITextField!
    @IBOutlet weak var skillTwoTextField: UITextField!
    @IBOutlet weak var skillThreeTextField: UITextField!
    @IBOutlet weak var skillFourTextField: UITextField!
    @IBOutlet weak var biddableTextLabel: UILabel!
    @IBOutlet weak var biddableSwitch: UISwitch!
    @IBOutlet weak var skillsLabel: UILabel!

    let fbMgr = FirebaseManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toggleUI(segment: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleUI(segment: Int) {
        var jobUIHidden: Bool
        var skillUIHidden: Bool
        
        if segment == 0 {
            jobUIHidden = false
            skillUIHidden = true
        }
        else {
            jobUIHidden = true
            skillUIHidden = false
        }
        
        jobTitleTextField.isHidden = jobUIHidden
        jobDescriptionTextView.isHidden = jobUIHidden
        skillsLabel.isHidden = skillUIHidden
        skillOneTextField.isHidden = skillUIHidden
        skillTwoTextField.isHidden = skillUIHidden
        skillThreeTextField.isHidden = skillUIHidden
        skillFourTextField.isHidden = skillUIHidden
        biddableTextLabel.isHidden = jobUIHidden
        biddableSwitch.isHidden = jobUIHidden
    }

    @IBAction func listingTypeSegDidChange(_ sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        toggleUI(segment: selectedIndex)
    }
    
    @IBAction func postButtonTapped(_ sender: AnyObject) {
        if listingTypeSegControl.selectedSegmentIndex == 0 {
            let date = Date().toStringFromDefaultDate()
            let description = jobDescriptionTextView.text!
            let title = jobTitleTextField.text!
            
            fbMgr.postJobListing(date: date, description: description, jobTitle: title)
        }
        else {
            
        }
    }
}
