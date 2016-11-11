//
//  SkillListingViewController.swift
//  AssistMe
//
//  Created by Bhavish on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class SkillListingViewController: UIViewController {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var skillOne: UILabel!
    @IBOutlet weak var skillTwo: UILabel!
    @IBOutlet weak var skillThree: UILabel!
    @IBOutlet weak var skillFour: UILabel!
    @IBOutlet weak var teamRating: UILabel!
    @IBOutlet weak var skillRating: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    var listing: Skill?
    let fbMgr = FirebaseManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        username.text = listing!.displayName
        skillOne.text = listing!.skillOne
        skillTwo.text = listing!.skillTwo
        skillThree.text = listing!.skillThree
        skillFour.text = listing!.skillFour
        date.text = listing!.date
        teamRating.text = listing!.rating.teamwork
        skillRating.text = listing!.rating.skill
        
        if listing!.uid == fbMgr.currentUser!.uid {
            messageButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func messageButtonTapped(_ sender: AnyObject) {
        let chatVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: Identifier.chat) as! ChatViewController
        chatVC.receiverId = listing!.uid
        chatVC.receiverDisplayName = listing!.displayName
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
