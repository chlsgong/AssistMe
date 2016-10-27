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
    
    //TODO: Needs functionality testing
    
    var alertController:UIAlertController? = nil
    var loginTextField: UITextField? = nil
    var passwordTextField: UITextField? = nil
    
    let user = FIRAuth.auth()?.currentUser
    
    var ref: FIRDatabaseReference!
    
    init() {
        ref = FIRDatabase.database().reference()
    }
    
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
        self.alertController = UIAlertController(title: "Change Description", message: "Enter your new description", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Describe yourself"
        }
        self.presentViewController(self.alertController!, animated: true, completion: nil)
        
        
        // Not sure if this needs the whole commit change with completion stuff the others need since it accesses the data differently
        self.ref.child("profile/(user.uid)/description").setValue(self.loginTextField!.text!)
        
        self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(OKAction)
                
        self.presentViewController(self.alertController!, animated: true, completion:nil)
    }
    
    @IBAction func editSkillsButton(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Edit Skills", message: "What are your skills?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "List skills here"
        }
        self.presentViewController(self.alertController!, animated: true, completion: nil)
        
        
        // Not sure if this needs the whole commit change with completion stuff the others need since it accesses the data differently
        self.ref.child("profile/(user.uid)/skills").setValue(self.loginTextField!.text!)
        
        self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(OKAction)
        
        self.presentViewController(self.alertController!, animated: true, completion:nil)
    }
    
    @IBAction func changeProfilePictureButton(sender: AnyObject) {
        // Not sure how to go about getting images from anything other than a URL
        let changeRequest = user.profileChangeRequest()
        
        self.alertController = UIAlertController(title: "Change Profile Picture", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter image url"
        }
        
        self.presentViewController(self.alertController!, animated: true, completion: nil)
        
        changeRequest.photoURL = self.loginTextField!.text!
        
        changeRequest.commitChangesWithCompletion { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Change failed", message: "Unable to change profile picture", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Success", message: "Your profile picture has been changed.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
                self.alertController!.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                self.alertController!.addAction(OKAction)
                
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            }
        }
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
