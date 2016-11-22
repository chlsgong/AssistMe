//
//  StartUpViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/17/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToStartUp(segue: UIStoryboardSegue) {
        print("Unwind to Start Up")
    }

}
