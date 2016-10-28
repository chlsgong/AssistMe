//
//  LoginViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/24/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let fbMgr = FirebaseManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorMessageLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesEnded(touches, with: event)
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        // disable login button
        loginButton.isEnabled = false
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if Utility.validEmail(email: email) {
            fbMgr.signIn(email: email, password: password) { error in
                if error == nil {
                    self.performSegue(withIdentifier: Identifier.loggedIn, sender: nil)
                }
                else {
                    self.errorMessageLabel.text = error?.localizedDescription
                    self.errorMessageLabel.isHidden = false
                    self.loginButton.isEnabled = true
                }
            }
        }
        else {
            self.errorMessageLabel.text = "\(ErrorMessage.invalidEmail)"
            self.errorMessageLabel.isHidden = false
            self.loginButton.isEnabled = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
