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
    
    var passwordTextField: UITextField? = nil
    
    let imagesRef: FIRStorageReference = {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://assistme-e8c05.appspot.com")
        return storageRef.child("images")
    }()
    
    let user = FIRAuth.auth()?.currentUser
    
    var ref = FIRDatabase.database().reference()
    
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
        
        let alert = UIAlertController.textAlertController(withTitle: "Change email", message: "Please enter a new email", placeholderText: "Email") { text in
            self.user?.updateEmail("\(text)") { error in
                if let _ = error {
                    self.showErrorAlert(withMessage: "Change Failed")
                } else {
                    self.showSuccessAlert(withMessage: "Your email has been changed")
                }
            }
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        FirebaseManager.manager.signOut()
    }
    
    @IBAction func deleteAccountButton(sender: AnyObject) {
//        self.user?.delete { error in
//            if let _ = error {
//                self.alertController = UIAlertController(title: "Unable to delete account", message: "", preferredStyle: UIAlertControllerStyle.alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                self.alertController!.addAction(OKAction)
//                
//                self.present(self.alertController!, animated: true, completion:nil)
//            } else {
//                self.alertController = UIAlertController(title: "Account deleted", message: "", preferredStyle: UIAlertControllerStyle.alert)
//                
//                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                self.alertController!.addAction(OKAction)
//                
//                self.present(self.alertController!, animated: true, completion:nil)
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoPickerSegue", let photoController = segue.destination as? PhotoPickerViewController {
            photoController.delegate = self
        }
    }
    
    fileprivate func uploadProfilePicture(data: Data) {
        let profileRef = imagesRef.child("\(self.user!.uid).png")

        profileRef.put(data, metadata: nil) { metadata, error in
            if let _ = error {
                self.showErrorAlert(withMessage: "Unable to upload")
            } else {
                let downloadURL = metadata!.downloadURL()!
                
                let changeRequest = self.user?.profileChangeRequest()
                
                changeRequest?.photoURL = downloadURL
                
                changeRequest?.commitChanges { error in
                    if let _ = error {
                        self.showErrorAlert(withMessage: "Unable to change profile picture")
                    } else {
                        self.showSuccessAlert(withMessage: "Your profile picture has been changed.")
                    }
                }
            }
        }
    }
    
    private func showErrorAlert(withMessage message: String) {
        let alert = UIAlertController.errorAlert(withMessage: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessAlert(withMessage message: String) {
        let alert = UIAlertController.successAlert(withMessage: message)
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension SettingsTableViewController: PhotoPickerViewControllerDelegate {
    func didSelectImage(with data: Data, in viewController: PhotoPickerViewController) {
        self.navigationController?.popViewController(animated: true)

        uploadProfilePicture(data: data)
    }
}
