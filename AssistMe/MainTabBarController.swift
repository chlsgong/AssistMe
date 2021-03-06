//
//  MainTabBarController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/25/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabControllers()
        setupTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabControllers() {
        let jobListingVC = Utility.storyboard(forId: Identifier.jobListing).instantiateViewController(withIdentifier: Identifier.jobListingNav) as! UINavigationController
        let skillListingVC = Utility.storyboard(forId: Identifier.skillListing).instantiateViewController(withIdentifier: Identifier.skillListingNav) as! UINavigationController
        let createListingVC = Utility.storyboard(forId: Identifier.createListing).instantiateViewController(withIdentifier: Identifier.createListingNav) as! UINavigationController
        let segmentedVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: Identifier.commNav) as! UINavigationController
        let profileVC = Utility.storyboard(forId: Identifier.profile).instantiateViewController(withIdentifier: Identifier.profileNav) as! UINavigationController

        self.viewControllers = [jobListingVC, skillListingVC, createListingVC, segmentedVC, profileVC]
    }
    
    func setupTabBar() {
        self.tabBar.tintColor = UIColor.darkBlueColor()
        self.tabBar.isTranslucent = false
        
        let tabBarItems = self.tabBar.items
        tabBarItems?[0].setupTabBarItem(withImage: Asset.jobIcon)
        tabBarItems?[1].setupTabBarItem(withImage: Asset.skillIcon)
        tabBarItems?[2].setupTabBarItem(withImage: Asset.createIcon)
        tabBarItems?[3].setupTabBarItem(withImage: Asset.messageIcon)
        tabBarItems?[4].setupTabBarItem(withImage: Asset.profileIcon)
    }

}
