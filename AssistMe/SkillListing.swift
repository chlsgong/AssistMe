//
//  SkillListing.swift
//  AssistMe
//
//  Created by Bhavish on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class SkillListing {
    var username:String = ""
    var skillOne:String = ""
    var skillTwo: String = ""
    var skillThree: String = ""
    var skillFour: String = ""
    var date:String = ""
    var rating:Rating?
    
    init(username:String, skillOne:String, skillTwo:String, skillThree:String, skillFour:String, date:String, rating:Rating) {
        self.username = username
        self.skillOne = skillOne
        self.skillTwo = skillTwo
        self.skillThree = skillThree
        self.skillFour = skillFour
        self.date = date
        self.rating = rating
    }
}
