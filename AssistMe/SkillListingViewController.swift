//
//  SkillListingViewController.swift
//  AssistMe
//
//  Created by Bhavish on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class SkillListingViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var skillOne: UILabel!
    @IBOutlet weak var skillTwo: UILabel!
    @IBOutlet weak var skillThree: UILabel!
    @IBOutlet weak var skillFour: UILabel!
    
    var listing: SkillListing?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = listing!.username
        skillOne.text = listing!.skillOne
        skillTwo.text = listing!.skillTwo
        skillThree.text = listing!.skillThree
        skillFour.text = listing!.skillFour
        date.text = listing!.date

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
