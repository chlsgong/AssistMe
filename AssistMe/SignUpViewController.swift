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
    
//    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        ref = FIRDatabase.database().reference()
//        let childRef = ref.child("child")
//        childRef.setValue("CHILD 1")
        
        // SIGN IN CODE
//        FirebaseManager.manager.signIn(email: "gch_charles@yahoo.com", password: "charlesgong") { error in
//            if error != nil {
//                print(error!)
//            }
//            else {
//                print(FirebaseManager.manager.currentUser?.uid)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                print("sign in")
            }
            else {
                print(error?.localizedDescription)
                print("unsuccessful")
            }
        }
    }
    
}
