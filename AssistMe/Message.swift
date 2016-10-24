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
    let text: String
    
    init(sender: Sender, date: String, text: String) {
        self.sender = sender
        self.date = date
        self.text = text
    }
    
    convenience init(uid: String, displayName: String = "", date: String, text: String = "") {
        let sender = Sender(uid: uid, displayName: displayName)
        self.init(sender: sender, date: date, text: text)
    }
}
