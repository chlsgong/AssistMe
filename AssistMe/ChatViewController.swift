//
//  MessageViewController.swift
//  AssistMe
//
//  Created by Charles Gong on 10/15/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    let fbMgr = FirebaseManager.manager
    
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.senderId = fbMgr.currentUser!.uid
        self.senderDisplayName = fbMgr.currentUser!.displayName ?? "Charles"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JSQMessagesViewController delegate methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(text)
        print(senderId)
        print(senderDisplayName)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let dateString = dateFormatter.string(from: date)
        print(dateString)
    }

}
