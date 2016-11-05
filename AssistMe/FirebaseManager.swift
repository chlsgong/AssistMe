//
//  FirebaseManager.swift
//  AssistMe
//
//  Created by Charles Gong on 10/18/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static let manager = FirebaseManager()
    
    var currentUser: FIRUser?
    
    // Database Keys
    private let profile = "profile"
    private let message = "message"
    private let lastTextDate = "lastTextDate"
    private let displayName = "displayName"
    private let messageItem = "messageItem"
    private let text = "text"
    private let date = "date"
    private let sender = "sender"
    private let notification = "notification"
    
    private let rootNodeRef = FIRDatabase.database().reference()
    private let profileNodeRef: FIRDatabaseReference
    
    private init() {
        profileNodeRef = rootNodeRef.child(profile)
    }
    
    // MARK: - Authentication functions
    
    func addStateListener(listenerBlock: @escaping (FIRUser?) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener { _, user in
            self.currentUser = user
            listenerBlock(user)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            self.currentUser = user
            completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            self.currentUser = user
            completion(error)
        }
    }
    
    // Incomplete
    func signOut() {
        try! FIRAuth.auth()!.signOut()
        currentUser = nil
    }
    
    // MARK: - Database functions
    
    func sendMessage(toUID uid: String, displayName: String, text: String, date: String) {
        var keyNodeRef: FIRDatabaseReference
        var displayNameNodeRef: FIRDatabaseReference
        var lastTextDateNodeRef: FIRDatabaseReference
        var messageItemNodeRef: FIRDatabaseReference
        
        let messageItem = [
            self.text: text,
            self.date: date,
            self.sender: currentUser!.uid
        ]
                
        // Add to receiver's received node
        messageItemNodeRef = messageNodeRef(uid: uid).child(messageItemPath(uid: currentUser!.uid))
        keyNodeRef = messageItemNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
        // Update last text date for receiver
        lastTextDateNodeRef = messageNodeRef(uid: uid).child(lastTextDatePath(uid: currentUser!.uid))
        lastTextDateNodeRef.setValue(date)
        // Update sender's display name for receiver
        displayNameNodeRef = messageNodeRef(uid: uid).child(displayNamePath(uid: currentUser!.uid))
        displayNameNodeRef.setValue(currentUser!.displayName ?? "Charles")
        
        // Add to senders's sent node
        messageItemNodeRef = messageNodeRef(uid: currentUser!.uid).child(messageItemPath(uid: uid))
        keyNodeRef = messageItemNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
        // Update last text date for sender
        lastTextDateNodeRef = messageNodeRef(uid: currentUser!.uid).child(lastTextDatePath(uid: uid))
        lastTextDateNodeRef.setValue(date)
        // Update receiver's display name for sender
        displayNameNodeRef = messageNodeRef(uid: currentUser!.uid).child(displayNamePath(uid: uid))
        displayNameNodeRef.setValue(displayName)
    }
    
    func queryMessages(completion: @escaping (Message) -> Void) {
        query(forNodeRef: messageNodeRef(uid: currentUser!.uid), observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let uid = snapshot.key
            let displayName = properties[self.displayName] as! String
            let lastTextDate = properties[self.lastTextDate] as! String
            let message = Message(uid: uid, displayName: displayName, date: lastTextDate)
            
            completion(message)
        }
    }
    
    func updateMessages(completion: @escaping (Message) -> Void) {
        query(forNodeRef: messageNodeRef(uid: currentUser!.uid), observationType: .childChanged) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let uid = snapshot.key
            let displayName = properties[self.displayName] as! String
            let lastTextDate = properties[self.lastTextDate] as! String
            let message = Message(uid: uid, displayName: displayName, date: lastTextDate)
            
            completion(message)
        }
    }
    
    func queryMessageItems(forUID uid: String, messageItemHandler: @escaping (Message) -> Void) {
        let messageItemNodeRef = messageNodeRef(uid: currentUser!.uid).child(messageItemPath(uid: uid))
        
        query(forNodeRef: messageItemNodeRef, observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let senderUID = properties[self.sender] as! String
            let date = properties[self.date] as! String
            let text = properties[self.text] as! String
            
            let messageItem = Message(uid: senderUID, date: date, text: text)
            
            messageItemHandler(messageItem)
        }
    }
    
    // MARK: - Helper functions
    
    // uid/displayName
    private func displayNamePath(uid: String) -> String {
        return "\(uid)/\(displayName)"
    }
    
    // uid/lastTextDate
    private func lastTextDatePath(uid: String) -> String {
        return "\(uid)/\(lastTextDate)"
    }
    
    // uid/messageItem
    private func messageItemPath(uid: String) -> String {
        return "\(uid)/\(messageItem)"
    }
    
    private func uidNodeRef(uid: String) -> FIRDatabaseReference {
        return profileNodeRef.child(uid)
    }
    
    private func messageNodeRef(uid: String) -> FIRDatabaseReference {
        let messagePath = "\(uid)/\(message)"
        return profileNodeRef.child(messagePath)
    }
    
    private func query(forNodeRef nodeRef: FIRDatabaseReference, observationType: FIRDataEventType, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = nodeRef.queryLimited(toLast: 25)
        query.observe(observationType) { snapshot in
            snapshotHandler(snapshot)
        }        
    }
    
}
