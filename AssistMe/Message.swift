//
//  Message.swift
//  AssistMe
//
//  Created by Charles Gong on 10/19/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Message {
    let sender: String
    let date: String
    
    init(sender: String, date: String) {
        self.sender = sender
        self.date = date
    }
}
