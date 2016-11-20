//
//  UIAlertController+Helpers.swift
//  AssistMe
//
//  Created by Milla J. Vilkki on 11/20/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    class func successAlert(withMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(OKAction)
        
        return alertController
    }
    
    class func errorAlert(withMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Change failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(OKAction)
        
        return alertController
    }
    
    class func textAlertController(withTitle title: String, message: String, placeholderText placeholder: String, completion: ((String?)->())?) -> UIAlertController {
        var alertTextField: UITextField?
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = placeholder
            alertTextField = textField
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { alertAction in
            completion?(alertTextField?.text)
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
