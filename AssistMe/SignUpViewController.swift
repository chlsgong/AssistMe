//
//  ViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/11/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
        
    let fbMgr = FirebaseManager.manager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.errorMessageLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesEnded(touches, with: event)
    }

    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        // disable sign up button
        signUpButton.isEnabled = false
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if Utility.validEmail(email: email) && password == confirmPassword {
            fbMgr.signUp(email: email, password: password) { error in
                if error == nil {
                    self.performSegue(withIdentifier: Identifier.signedUp, sender: nil)
                }
                else {
                    self.errorMessageLabel.text = error?.localizedDescription
                    self.errorMessageLabel.isHidden = false
                    self.signUpButton.isEnabled = true
                }
            }
        }
        else {
            self.errorMessageLabel.text = "\(ErrorMessage.invalidEmail) or \(ErrorMessage.confirmPassword)"
            self.errorMessageLabel.isHidden = false
            self.signUpButton.isEnabled = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
