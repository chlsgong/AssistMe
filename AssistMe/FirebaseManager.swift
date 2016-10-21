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
    private let received = "received"
    private let sent = "sent"
    private let text = "text"
    private let date = "date"
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
    
    func sendMessage(toUID uid: String, text: String, date: String) {
        var keyNodeRef: FIRDatabaseReference
        
        let messageItem = [
            self.text: text,
            self.date: date
        ]
        
        // Add to receiver's received node
        let receivedNodeRef = messageNodeRef(uid: uid).child(receivedPath(uid: currentUser!.uid))
        keyNodeRef = receivedNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
        
        // Add to senders's sent node
        let sentNodeRef = messageNodeRef(uid: currentUser!.uid).child(sentPath(uid: uid))
        keyNodeRef = sentNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
    }
    
    func queryMessages(completion: @escaping ([Message]) -> Void) {
        query(forNodeRef: uidNodeRef()) { snapshot in
            var messages = [Message]()
            
            for child in snapshot.children {
                let childSnapshot = child as! FIRDataSnapshot
                let properties = childSnapshot.value as! NSDictionary
                let uid = childSnapshot.key
                let displayName = properties[self.displayName] as! String
                let date = properties[self.lastTextDate] as! String
                let message = Message(uid: uid, displayName: displayName, date: date)
                
                messages.append(message)
            }
            
            completion(messages)
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
    
    // uid/received
    private func receivedPath(uid: String) -> String {
        return "\(uid)/\(received)"
    }
    
    // uid/sent
    private func sentPath(uid: String) -> String {
        return "\(uid)/\(sent)"
    }
    
    private func uidNodeRef() -> FIRDatabaseReference {
        return profileNodeRef.child(currentUser!.uid)
    }
    
    private func messageNodeRef(uid: String) -> FIRDatabaseReference {
        let messagePath = "\(uid)/\(message)"
        return profileNodeRef.child(messagePath)
    }
    
    private func query(forNodeRef nodeRef: FIRDatabaseReference, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = nodeRef.queryLimited(toLast: 25)
        query.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            snapshotHandler(snapshot)
        }
    }
    
}
