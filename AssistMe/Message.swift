//
//  Message.swift
//  AssistMe
//
//  Created by Charles Gong on 10/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Message {
    let sender: Sender
    let date: String
    
    init(uid: String, displayName: String, date: String) {
        self.sender = Sender(uid: uid, displayName: displayName)
        self.date = date
    }
}
