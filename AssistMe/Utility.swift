//
//  Utility.swift
//  AssistMe
//
//  Created by Charles Gong on 10/15/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class Utility {
    class func storyboard(forId id: String) -> UIStoryboard {
        return UIStoryboard(name: id, bundle: .main)
    }
}

struct Identifier {
    // Storyboards
    static let main = "Main"
    static let communication = "Communication"
    
    // View Controllers
    static let message = "Message"
    static let notification = "Notification"
    
    // TableView Cells
    static let messageCell = "MessageCell"
    
    // Segues
    static let showChat = "ShowChat"
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
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: self)
    }
}
