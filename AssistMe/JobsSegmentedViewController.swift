//
//  JobsSegmentedViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 11/17/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class JobsSegmentedViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    let currentJobsStoryboard = Utility.storyboard(forId: Identifier.currentJobs)
    
    lazy var myJobsTableViewController: MyJobsTableViewController = {
        let controller = self.currentJobsStoryboard.instantiateViewController(withIdentifier: Identifier.myJobs) as! MyJobsTableViewController
        self.addViewControllerAsChild(viewController: controller)
        
        return controller
    }()
    
    lazy var jobRequestsTableViewController: JobRequestsTableViewController = {
        let controller = self.currentJobsStoryboard.instantiateViewController(withIdentifier: Identifier.jobRequests) as! JobRequestsTableViewController
        self.addViewControllerAsChild(viewController: controller)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        updateView(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViewControllerAsChild(viewController: UIViewController) {
        self.addChildViewController(viewController)
        
        viewController.view.frame = containerView.frame
        viewController.view.addConstraints(containerView.constraints)
        self.view.addSubview(viewController.view)
        
        viewController.didMove(toParentViewController: self)
    }
    
    func updateView(index: Int) {
        myJobsTableViewController.view.isHidden = !(index == 0)
        jobRequestsTableViewController.view.isHidden = (index == 0)
    }
    
    @IBAction func segmentDidChange(_ sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        updateView(index: selectedIndex)
        self.navigationItem.title = segmentedControl.titleForSegment(at: selectedIndex)
    }
    
    @IBAction func exitButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
