//
//  EditInfoViewController.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 11/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class EditInfoViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var skillsTableView: UITableView!
    
    let user = FIRAuth.auth()?.currentUser
    
    var ref = FIRDatabase.database().reference()
    
    var skills: [String : String] = [:]
    var skillsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("profile").child(user!.uid).child("skills").observeSingleEvent(of: .value, with: { (snapshot) in
            if let skillsDictionary = snapshot.value as? [String : String] {
                self.skills = skillsDictionary
                self.createSkillsArray()
                self.skillsTableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    func createSkillsArray() {
        for (_, value) in skills {
            skillsArray.append(value)
        }
    }
    
    
    @IBAction func addSkill() {
        let alert = UIAlertController.textAlertController(withTitle: "Add Skill", message: "", placeholderText: "Skill") { text in
            if let text = text {
                for (_, value) in self.skills {
                    if value == text {
                        let alert = UIAlertController.errorAlert(withMessage: "This skill already exists")
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                let uuid = UUID().uuidString
                self.skills[uuid] = text
                self.skillsArray.append(text)
                self.skillsTableView.reloadData()
                self.ref.child("profile/\(self.user!.uid)/skills/\(uuid)").setValue(text)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func userNameSaveButton() {
        if usernameTextField.text!.isEmpty {
        } else {
            let changeRequest = user?.profileChangeRequest()
            
            changeRequest?.displayName = usernameTextField.text
            
            changeRequest?.commitChanges{ error in
                if let _ = error {
                    self.showErrorAlert(withMessage: "Unable to change username.")
                } else {
                    self.showSuccessAlert(withMessage: "Your username has been changed.")
                }
            }
        }
    }
    
    @IBAction func emailSaveButton() {
        if emailTextField.text!.isEmpty {
        } else {
            FIRAuth.auth()?.currentUser?.updateEmail(emailTextField.text!) { (error) in
                if let _ = error {
                    self.showErrorAlert(withMessage: "Change Failed")
                } else {
                    self.showSuccessAlert(withMessage: "Your email has been changed")
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

extension EditInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillcell", for: indexPath)
        cell.textLabel?.text = skillsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension EditInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentValue = skillsArray[indexPath.row]
            for (key, value) in skills {
                if value == currentValue {
                    self.ref.child("profile/\(self.user!.uid)/skills/\(key)").removeValue()
                    skills.removeValue(forKey: key)
                    skillsArray.remove(at: indexPath.row)
                    skillsTableView.deleteRows(at: [indexPath], with: .automatic)
                    return
                }
            }
        }
    }
}
