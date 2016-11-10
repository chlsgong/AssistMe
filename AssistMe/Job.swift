//
//  Job.swift
//  AssistMe
//
//  Created by Charles Gong on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Job {
    let uid: String
    let displayName: String
    let date: String
    let description: String
    let title: String
    let rating: Rating
    
    init(uid: String, displayName: String, date: String, description: String, title: String, rating: Rating) {
        self.uid = uid
        self.displayName = displayName
        self.date = date
        self.description = description
        self.title = title
        self.rating = rating
    }
}
