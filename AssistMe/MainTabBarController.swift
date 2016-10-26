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
        
        let segmentedVC = Utility.storyboard(forId: Identifier.communication).instantiateViewController(withIdentifier: "CommunicationNav") as! UINavigationController
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = UIColor.orange
        
        self.viewControllers = [segmentedVC, firstVC]
        
        let tabBarItems = self.tabBar.items
        tabBarItems?[0].image = UIImage(named: "MessageIcon")
//        tabBarItems?[0].selectedImage = UIImage(named: "MessageIcon")
        tabBarItems?[0].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItems?[1].image = UIImage(named: "ProfileIcon")
//        tabBarItems?[1].selectedImage = UIImage(named: "ProfileIcon")
        tabBarItems?[1].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
