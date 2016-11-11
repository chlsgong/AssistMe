//
//  Skill.swift
//  AssistMe
//
//  Created by Charles Gong on 11/9/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Skill {
    var uid: String
    var displayName: String
    var skillOne: String
    var skillTwo: String
    var skillThree: String
    var skillFour: String
    var date: String
    var rating: Rating
    
    init(uid: String, displayName: String, skillOne: String, skillTwo: String, skillThree: String, skillFour: String, date: String, rating: Rating) {
        self.uid = uid
        self.displayName = displayName
        self.skillOne = skillOne
        self.skillTwo = skillTwo
        self.skillThree = skillThree
        self.skillFour = skillFour
        self.date = date
        self.rating = rating
    }
}
