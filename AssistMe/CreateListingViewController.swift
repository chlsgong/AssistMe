//
//  CreateListingViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/9/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class CreateListingViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
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

    var confirmPostAlert: UIAlertController!
    
    let fbMgr = FirebaseManager.manager
    var shouldEmptyTextView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toggleUI(segment: 0)
        
        setupUI()
        
        confirmPostAlert = setupAlertView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesEnded(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if shouldEmptyTextView {
            textView.text = ""
            shouldEmptyTextView = false
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.endEditing(true)
            return false
        }
        return true
    }
    
    func setupUI() {
        usernameLabel.text = fbMgr.currentUser?.displayName
        
        jobTitleTextField.delegate = self
        jobDescriptionTextView.delegate = self
        jobDescriptionTextView.layer.borderColor = UIColor.darkBlueColor().cgColor
        jobDescriptionTextView.layer.borderWidth = 0.5
        jobDescriptionTextView.layer.cornerRadius = 3.5
        
        skillOneTextField.delegate = self
        skillTwoTextField.delegate = self
        skillThreeTextField.delegate = self
        skillFourTextField.delegate = self
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
    
    func setupAlertView() -> UIAlertController {
        let alertController = UIAlertController(title: "Posted Complete", message: "Your post has been successfully posted on the listings feed.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        
        return alertController
    }

    @IBAction func listingTypeSegDidChange(_ sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        toggleUI(segment: selectedIndex)
    }
    
    @IBAction func postButtonTapped(_ sender: AnyObject) {
        let date = Date().toStringFromDefaultDate()

        if listingTypeSegControl.selectedSegmentIndex == 0 {
            let description = jobDescriptionTextView.text!
            let title = jobTitleTextField.text!
            
            fbMgr.postJobListing(date: date, description: description, jobTitle: title)
            
            jobDescriptionTextView.text = ""
            jobTitleTextField.text = ""
        }
        else {
            let skillOne = skillOneTextField.text!
            let skillTwo = skillTwoTextField.text!
            let skillThree = skillThreeTextField.text!
            let skillFour = skillFourTextField.text!
            
            fbMgr.postSkillsListing(date: date, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour)
            
            skillOneTextField.text = ""
            skillTwoTextField.text = ""
            skillThreeTextField.text = ""
            skillFourTextField.text = ""
        }
        
        self.present(confirmPostAlert, animated: true, completion: nil)
    }
}
