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
    
    // Reference paths
    private let profile = "profile"
    private let message = "profile/message"
    private let username = "profile/username"
    private let notification = "profile/notification"
    
    // Database Keys
    private let lastTextDate = "lastTextDate"
    
    private let rootRef = FIRDatabase.database().reference()
    private let profileNodeRef: FIRDatabaseReference
    private let messageNodeRef: FIRDatabaseReference
    
    private init() {
        profileNodeRef = rootRef.child(profile)
        messageNodeRef = rootRef.child(message)
    }
    
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
    
    func queryMessages(messageHandler: @escaping (String, String) -> Void) {
        query(forNodeRef: messageNodeRef) { snapshot in
            let sender = snapshot.key
            let snapshotJSON = snapshot.value as! NSDictionary
            let date = snapshotJSON[self.lastTextDate] as! String
            
            messageHandler(sender, date)
        }
    }
    
    private func query(forNodeRef nodeRef: FIRDatabaseReference, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = nodeRef.queryLimited(toLast: 25)
        query.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            snapshotHandler(snapshot)
        }
    }
}
