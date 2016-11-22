//
//  SegmentedViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/15/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedView: UIView!
    
    let fbMgr = FirebaseManager.manager
    let communicationStoryboard = Utility.storyboard(forId: Identifier.communication)
    
    lazy var messageTableViewController: MessageTableViewController = {
        let controller = self.communicationStoryboard.instantiateViewController(withIdentifier: Identifier.message) as! MessageTableViewController
        self.addViewControllerAsChild(viewController: controller)
        
        return controller
    }()
    
    lazy var notificationTableViewController: NotificationTableViewController = {
        let controller = self.communicationStoryboard.instantiateViewController(withIdentifier: Identifier.notification) as! NotificationTableViewController
        self.addViewControllerAsChild(viewController: controller)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.changeBackButtonTitle(title: "")
    }
    
    override func viewDidLayoutSubviews() {
        updateView(index: 0)
        segmentedView.addBottomBorder()
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
        messageTableViewController.view.isHidden = !(index == 0)
        notificationTableViewController.view.isHidden = (index == 0)
    }
    
    @IBAction func segmentedControlChanged(_ sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        updateView(index: selectedIndex)
        self.navigationItem.title = segmentedControl.titleForSegment(at: selectedIndex)
    }
    
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ToStartUp", sender: nil)
        fbMgr.signOut()
    }
    
}
