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

class SettingsTableViewController: UITableViewController {
    // TODO: Add buttons for changing image, description, and skills
    
    var alertController:UIAlertController? = nil
    var loginTextField: UITextField? = nil
    var passwordTextField: UITextField? = nil
    
    let user = FIRAuth.auth()?.currentUser
    
    @IBAction func changeUsernameButton(sender: AnyObject) {
        let changeRequest = user.profileChangeRequest()
        
        self.alertController = UIAlertController(title: "Change Username", message: "Please enter a new username.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter your username"
        }
        
        self.presentViewController(self.alertController!, animated: true, completion: nil)
        
        changeRequest.displayName = self.loginTextField!.text!
        
        changeRequest.commitChangesWithCompletion { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Change failed", message: "Unable to change username", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
                self.alertController!.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func editDescriptionButton(sender: AnyObject) {
       //TODO: Access Description
    }
    
    @IBAction func editSkillsButton(sender: AnyObject) {
        // TODO: Create a skills database entry and then access it
    }
    
    @IBAction func changeProfilePictureButton(sender: AnyObject) {
        // TODO: Add picture choosing functionality
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
        let email = user?.email
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Unable to reset", message: "Email not sent", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Reset Successful", message: "Password reset email sent", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
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
                self.alertController = UIAlertController(title: "Unable to authenticate", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Change email", message: "Please enter a new email.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                
                self.alertController!.addAction(OKAction)
                self.alertController!.addAction(cancelAction)
                
                self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
                    self.loginTextField = textField
                    self.loginTextField?.placeholder = "Enter your email"
                }
                
                user?.updateEmail("\(self.loginTextField!)") { error in
                    if let error = error {
                        self.alertController = UIAlertController(title: "Change failed", message: "Unable to change email", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        self.alertController!.addAction(OKAction)
                        
                        self.presentViewController(self.alertController!, animated: true, completion:nil)
                    } else {
                        self.alertController = UIAlertController(title: "Success", message: "Your email has been changed", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        self.alertController!.addAction(OKAction)
                        
                        self.presentViewController(self.alertController!, animated: true, completion:nil)
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
                self.alertController = UIAlertController(title: "Unable to authenticate", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else {
                user?.deleteWithCompletion { error in
                    if let error = error {
                        self.alertController = UIAlertController(title: "Unable to delete account", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        self.alertController!.addAction(OKAction)
                        
                        self.presentViewController(self.alertController!, animated: true, completion:nil)
                    } else {
                        self.alertController = UIAlertController(title: "Account deleted", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        self.alertController!.addAction(OKAction)
                        
                        self.presentViewController(self.alertController!, animated: true, completion:nil)
                    }
                }
            }
        }
    }
}
