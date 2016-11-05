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
    
    var ref = FIRDatabase.database().reference()
    
    @IBAction func changeUsernameButton(sender: AnyObject) {
        let changeRequest = user?.profileChangeRequest()
        
        self.alertController = UIAlertController(title: "Change Username", message: "Please enter a new username.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter your username"
        }
        
        self.present(self.alertController!, animated: true, completion: nil)
        
        changeRequest?.displayName = self.loginTextField!.text!
        
        changeRequest?.commitChanges { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Change failed", message: "Unable to change username", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                self.alertController!.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func editDescriptionButton(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Change Description", message: "Enter your new description", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Describe yourself"
        }
        self.present(self.alertController!, animated: true, completion: nil)
        
        
        // Not sure if this needs the whole commit change with completion stuff the others need since it accesses the data differently
        self.ref.child("profile/\(user?.uid)/description").setValue(self.loginTextField!.text!)
        
        self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.alert)
                
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(OKAction)
                
        self.present(self.alertController!, animated: true, completion:nil)
    }
    
    @IBAction func editSkillsButton(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Edit Skills", message: "What are your skills?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "List skills here"
        }
        self.present(self.alertController!, animated: true, completion: nil)
        
        
        // Not sure if this needs the whole commit change with completion stuff the others need since it accesses the data differently
        self.ref.child("profile/\(user?.uid)/skills").setValue(self.loginTextField!.text!)
        
        self.alertController = UIAlertController(title: "Success", message: "Your username has been changed.", preferredStyle: UIAlertControllerStyle.alert)
        
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(OKAction)
        
        self.present(self.alertController!, animated: true, completion:nil)
    }
    
    @IBAction func changeProfilePictureButton(sender: AnyObject) {
        // Not sure how to go about getting images from anything other than a URL
        let changeRequest = user?.profileChangeRequest()
        
        self.alertController = UIAlertController(title: "Change Profile Picture", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        
        self.alertController!.addAction(OKAction)
        self.alertController!.addAction(cancelAction)
        
        self.alertController!.addTextField { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = "Enter image url"
        }
        
        self.present(self.alertController!, animated: true, completion: nil)
        
        changeRequest?.photoURL = URL(string: self.loginTextField!.text!)
        
        changeRequest?.commitChanges { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Change failed", message: "Unable to change profile picture", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Success", message: "Your profile picture has been changed.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                self.alertController!.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
        let email = user?.email
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if let error = error {
                self.alertController = UIAlertController(title: "Unable to reset", message: "Email not sent", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            } else {
                self.alertController = UIAlertController(title: "Reset Successful", message: "Password reset email sent", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                self.alertController!.addAction(OKAction)
                
                self.present(self.alertController!, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func connectVenmoButton(sender: AnyObject) {
        // Not included for this build
    }
    
    @IBAction func changeEmailButton(sender: AnyObject) {
        var credential: FIRAuthCredential
        
//        user?.reauthenticate(with: credential) { error in
//            if let error = error {
//                self.alertController = UIAlertController(title: "Unable to authenticate", message: "", preferredStyle: UIAlertControllerStyle.alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                self.alertController!.addAction(OKAction)
//                
//                self.present(self.alertController!, animated: true, completion:nil)
//            } else {
                self.alertController = UIAlertController(title: "Change email", message: "Please enter a new email.", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                
                self.alertController!.addAction(OKAction)
                self.alertController!.addAction(cancelAction)
                
                self.alertController!.addTextField { (textField) -> Void in
                    self.loginTextField = textField
                    self.loginTextField?.placeholder = "Enter your email"
                }
                
                self.user?.updateEmail("\(self.loginTextField!)") { error in
                    if let error = error {
                        self.alertController = UIAlertController(title: "Change failed", message: "Unable to change email", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        self.alertController!.addAction(OKAction)
                        
                        self.present(self.alertController!, animated: true, completion:nil)
                    } else {
                        self.alertController = UIAlertController(title: "Success", message: "Your email has been changed", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        self.alertController!.addAction(OKAction)
                        
                        self.present(self.alertController!, animated: true, completion:nil)
                    }
                }
//            }
//        }
        
    }
    
     @IBAction func logOutButton(sender: AnyObject) {
        FirebaseManager.manager.signOut()
    }
    
    @IBAction func deleteAccountButton(sender: AnyObject) {
        var credential: FIRAuthCredential
        
//         user?.reauthenticate(with: credential) { error in
//            if let error = error {
//                self.alertController = UIAlertController(title: "Unable to authenticate", message: "", preferredStyle: UIAlertControllerStyle.alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                self.alertController!.addAction(OKAction)
//                
//                self.present(self.alertController!, animated: true, completion:nil)
//            } else {
                self.user?.delete { error in
                    if let error = error {
                        self.alertController = UIAlertController(title: "Unable to delete account", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        self.alertController!.addAction(OKAction)
                        
                        self.present(self.alertController!, animated: true, completion:nil)
                    } else {
                        self.alertController = UIAlertController(title: "Account deleted", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        self.alertController!.addAction(OKAction)
                        
                        self.present(self.alertController!, animated: true, completion:nil)
                    }
                }
//            }
//        }
    }

}
