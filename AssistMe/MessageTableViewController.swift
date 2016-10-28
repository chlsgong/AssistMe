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
        
        retrieveMessages()
        updateMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMessages() {
        fbMgr.queryMessages { message in
            self.messages.append(message)
            self.tableView.reloadData()
        }
    }
    
    func updateMessages() {
        fbMgr.updateMessages { message in
            self.messages = self.messages.map {
                if $0.sender.uid == message.sender.uid {
                    return message
                }
                return $0
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.showChat {
            let cell = sender as! UITableViewCell
            let destination = segue.destination as! ChatViewController
            let message = messages[self.tableView.indexPath(for: cell)!.row]
            
            destination.receiverId = message.sender.uid
            destination.receiverDisplayName = message.sender.displayName
        }
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
        let message =  messages[indexPath.row]
        
        cell.textLabel?.text = message.sender.displayName
        cell.detailTextLabel?.text = message.date

        return cell
    }

}
