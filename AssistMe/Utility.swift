//
//  Utility.swift
//  AssistMe
//
//  Created by Charles Gong on 10/15/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class Utility {
    class func storyboard(forId id: String) -> UIStoryboard {
        return UIStoryboard(name: id, bundle: .main)
    }
    
    class func validEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
}

struct Identifier {
    // Storyboards
    static let main = "Main"
    static let communication = "Communication"
    static let profile = "Profile"
    
    // View Controllers
    static let startUp = "StartUp"
    static let mainTabs = "MainTabs"
    static let commNav = "CommunicationNav"
    static let message = "Message"
    static let notification = "Notification"
    static let profileNav = "ProfileNav"
    
    // TableView Cells
    static let messageCell = "MessageCell"
    
    // Segues
    static let signedUp = "SignedUp"
    static let loggedIn = "LoggedIn"
    static let showChat = "ShowChat"
}

struct Asset {
    static let messageIcon = "MessageIcon"
    static let profileIcon = "ProfileIcon"
}

struct ErrorMessage {
    static let invalidEmail = "Invalid characters in email address."
    static let confirmPassword = "Passwords do not match."
}

// MARK: - Extensions

extension UIView {
    func addBottomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.layer.frame.height - 0.5, width: self.layer.frame.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}

extension UINavigationItem {
    func changeBackButtonTitle(title: String) {
        self.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: self)
    }
    func toStringWithJSQFormatter() -> String {
        let formatter = JSQMessagesTimestampFormatter.shared()
        return formatter!.timestamp(for: self)
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: self)
    }
}

extension UIColor {
    class func darkBlueColor() -> UIColor {
        return UIColor(colorLiteralRed: 40/255, green: 75/255, blue: 99/255, alpha: 1)
    }
}

extension UITabBarItem {
    func setupTabBarItem(withImage image: String) {
        self.image = UIImage(named: image)
        self.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
}
