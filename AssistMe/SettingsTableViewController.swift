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
        
    var alertController:UIAlertController? = nil
    var loginTextField: UITextField? = nil
    var passwordTextField: UITextField? = nil
    
    let user = FIRAuth.auth()?.currentUser
    
    var ref = FIRDatabase.database().reference()
    
    @IBAction func changeUsernameButton(sender: AnyObject) {
        let changeRequest = user?.profileChangeRequest()
        
        showTextAlertController(withTitle: "Change Username", message: "Please enter a new username.", placeholderText: "Enter your username") {
            changeRequest?.displayName = self.loginTextField!.text!
            
            changeRequest?.commitChanges { error in
                if let _ = error {
                    self.showErrorAlert(withMessage: "Unable to change username")
                } else {
                    self.showSuccessAlert(withMessage: "Your username has been changed.")
                }
            }
        }
    }
    
    @IBAction func editDescriptionButton(sender: AnyObject) {
        showTextAlertController(withTitle: "Change Description", message: "Enter your new description", placeholderText: "Describe yourself") {
            self.ref.child("profile/\(self.user!.uid)/description").setValue(self.loginTextField!.text!)
            
            self.showSuccessAlert(withMessage: "Your description has been changed.")
        }
    }
    
    @IBAction func editSkillsButton(sender: AnyObject) {
        showTextAlertController(withTitle: "Edit Skills", message: "What are your skills?", placeholderText: "List skills here") {
            self.ref.child("profile/\(self.user!.uid)/skills").setValue(self.loginTextField!.text!)
            
            self.showSuccessAlert(withMessage: "Your skills have been changed.")
        }
    }
    
    @IBAction func changeProfilePictureButton(sender: AnyObject) {
        // Not sure how to go about getting images from anything other than a URL
        showTextAlertController(withTitle: "Change Profile Picture", message: "", placeholderText: "Enter image url") {
            let changeRequest = self.user?.profileChangeRequest()
            
            changeRequest?.photoURL = URL(string: self.loginTextField!.text!)
            
            changeRequest?.commitChanges { error in
                if let _ = error {
                    self.showErrorAlert(withMessage: "Unable to change profile picture")
                } else {
                    self.showSuccessAlert(withMessage: "Your profile picture has been changed.")
                }
            }

        }
        
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
        let email = user?.email
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if let _ = error {
                self.showErrorAlert(withMessage: "Email not sent")
            } else {
                self.showSuccessAlert(withMessage: "Password reset email sent")
            }
        }
    }
    
    @IBAction func connectVenmoButton(sender: AnyObject) {
        // Not included for this build
    }
    
    @IBAction func changeEmailButton(sender: AnyObject) {
//        var credential: FIRAuthCredential
        
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
                    if let _ = error {
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
//        var credential: FIRAuthCredential
        
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
                    if let _ = error {
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
    
    
    //MARK: - helper alert functions
    
    private func showSuccessAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func showErrorAlert(withMessage message: String) {
        self.alertController = UIAlertController(title: "Change failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        self.alertController!.addAction(OKAction)
        
        self.present(self.alertController!, animated: true, completion:nil)
    }
    
    private func showTextAlertController(withTitle title: String, message: String, placeholderText placeholder: String, completion: (()->())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { alertAction in
            completion?()
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) -> Void in
            self.loginTextField = textField
            self.loginTextField?.placeholder = placeholder
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

}
