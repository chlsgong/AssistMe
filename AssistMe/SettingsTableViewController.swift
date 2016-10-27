//
//  SettingsTableViewController.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 10/23/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var alertController:UIAlertController? = nil
    var loginTextField: UITextField? = nil
    var passwordTextField: UITextField? = nil
    
    let user = FIRAuth.auth()?.currentUser
    
    @IBAction func changeUsernameButton(sender: AnyObject) {
        let changeRequest = user.profileChangeRequest()
        
        self.alertController = UIAlertController(title: "Change Username", message: "Please enter a new username.", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter your username"

        
        changeRequest.displayName = self.loginTextField!.text!
        changeRequest.commitChangesWithCompletion { error in
            if let error = error {
                // An error happened.
            } else {
                
                // Profile updated.
            }
        }
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
        let email = user?.email
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if let error = error {
                // An error happened.
            } else {
                // Password reset email sent.
            }
        }
    }
    
    @IBAction func connectVenmoButton(sender: AnyObeject) {
        // Not included for this build
    }
    
    @IBAction func changeEmailButton(sender: AnyObject) {
        var credential: FIRAuthCredential
        
        user?.reauthenticateWithCredential(credential) { error in
            if let error = error {
                // An error happened.
            } else {
                user?.updateEmail("user@example.com") { error in
                    if let error = error {
                        // An error happened.
                    } else {
                        // Email updated.
                    }
                }
            }
        }
        
    }
    
     @IBAction func logOutButton(sender: AnyObject) {
        user.signOut()
    }
    
    @IBAction func deleteAccountButton(sender: AnyObject) {
        var credential: FIRAuthCredential
        
         user?.reauthenticateWithCredential(credential) { error in
            if let error = error {
                // An error happened.
            } else {
                user?.deleteWithCompletion { error in
                    if let error = error {
                        // An error happened.
                    } else {
                        // Account deleted.
                    }
                }
            }
        }
    }
}