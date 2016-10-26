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
        let segmentedVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: Identifier.commNav) as! UINavigationController
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = UIColor.orange
        
        self.viewControllers = [segmentedVC, firstVC]
    }
    
    func setupTabBar() {
        self.tabBar.tintColor = UIColor.darkBlueColor()
        self.tabBar.isTranslucent = false
        
        let tabBarItems = self.tabBar.items
        tabBarItems?[0].setupTabBarItem(withImage: Asset.messageIcon)
        tabBarItems?[1].setupTabBarItem(withImage: Asset.profileIcon)
    }

}
