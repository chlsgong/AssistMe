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
    
    let user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet var settingsButton: UIBarButtonItem!
    
    func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsButton.title = NSString(string: "\u{2699}") as String
        if let font = UIFont(name: "Helvetica", size: 18.0) {
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        usernameLabel.text = user?.displayName
        profileImage.image = user?.photoURL
    }
    
}
