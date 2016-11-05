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
    
    let user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Not sure if this works; Supposed to make the settings button look like a little gear thing
        self.settingsButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }
        
        ref = FIRDatabase.database().reference()
        
        let userID = user?.uid
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            
            let properties = snapshot.value as! NSDictionary
            
            if let description = properties["description"] as? String {
                self.descriptionLabel.text = description
            }
            
            if let skills = properties["skills"] as? String {
                self.skillsLabel.text = skills
            }
            
        })
        
        usernameLabel.text = user?.displayName
        // profileImage.image = user?.photoURL
    }
    
}
