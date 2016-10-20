//
//  MessageTableViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/15/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewController: UITableViewController {
    let fbMgr = FirebaseManager.manager
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // send messages
//        let messageRef = FIRDatabase.database().reference().child("profile/message")
//        let senderRef = messageRef.child("User1234/received")
//        
//        let text = ["text": "First message yay!"]
//        senderRef.setValue(text)
        
        retrieveMessages()
        
        FirebaseManager.manager.addStateListener { _ in
            print("finished")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.messageCell, for: indexPath)
        
        cell.textLabel?.text = messages[indexPath.row].sender
        cell.detailTextLabel?.text = messages[indexPath.row].date

        return cell
    }
    
    func retrieveMessages() {
        fbMgr.queryMessages { sender, date in
            self.messages.append(Message(sender: sender, date: date))
            self.tableView.reloadData()
        }
    }
}
