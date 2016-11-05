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
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let fbMgr = FirebaseManager.manager
    
    var messages = [JSQMessage]()
    var receiverId: String!
    var receiverDisplayName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.senderId = fbMgr.currentUser!.uid
        self.senderDisplayName = fbMgr.currentUser!.displayName ?? "Charles"
        
        setupUI()
        
        retrieveMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationItem.title = receiverDisplayName
        
        self.edgesForExtendedLayout = []
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        setupChatBubbles()
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    func setupChatBubbles() {
        let factory = JSQMessagesBubbleImageFactory()!
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImage(with: UIColor.darkBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // MARK: - Message retrieval and sending functions
    
    func addMessage(senderId: String, senderDisplayName: String, date: Date, text: String) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)!
        messages.append(message)
    }
    
    func sendMessage(text: String, date: Date) {
        let dateString = date.toStringWithJSQFormatter()
        fbMgr.sendMessage(toUID: receiverId, displayName: receiverDisplayName, text: text, date: dateString)
        
        // addMessage(senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: date, text: text)
        
        // JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage(animated: true)
    }
    
    func retrieveMessages() {
        fbMgr.queryMessageItems(forUID: self.receiverId) { messageItem in
            let senderUID = messageItem.sender.uid
            let senderDisplayName = (senderUID == self.senderId ? self.senderDisplayName : self.receiverDisplayName)!
            // let date = messageItem.date.toDate()!
            let date = Date()
            let text = messageItem.text
            
            self.addMessage(senderId: senderUID, senderDisplayName: senderDisplayName, date: date, text: text)
            
            self.finishReceivingMessage(animated: true)
        }
    }
    
    // MARK: - JSQMessagesViewController and CollectionView delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            cell.textView!.textColor = UIColor.white
        }
        else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImageView
        }
        
        return incomingBubbleImageView
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        sendMessage(text: text, date: date)
    }

}
