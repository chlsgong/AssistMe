//
//  RatePartnerViewController.swift
//  AssistMe
//
//  Created by Bhavish on 11/21/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class RatePartnerViewController: UIViewController {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var teamworkRating: UILabel!
    @IBOutlet weak var skillRating: UILabel!
    @IBOutlet weak var teamworkStep: UIStepper!
    @IBOutlet weak var skillsStep: UIStepper!
    
    var username: String!
    var desc:String!
    var uid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamworkStep.maximumValue = 5
        skillsStep.maximumValue = 5
        teamworkRating.text = (teamworkStep.value).description
        skillRating.text = (skillsStep.value).description
        
        self.usernameLabel.text = username
        self.descTextView.text = desc
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func teamworkChanged(_ sender: UIStepper) {
        teamworkRating.text = sender.value.description
    }
    
    @IBAction func skillsChanged(_ sender: UIStepper) {
        skillRating.text = sender.value.description
    }
    
    @IBAction func submit(_ sender: Any) {
        let skills:Double = Double(skillRating.text!)!
        let teams:Double = Double(teamworkRating.text!)!
        
        FirebaseManager.manager.updateRatings(skills: skills, teamwork: teams, uid: uid)
    }
    
    func stepperValueChanged(sender: UIStepper) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
