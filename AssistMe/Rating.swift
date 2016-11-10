//
//  Rating.swift
//  AssistMe
//
//  Created by Charles Gong on 11/9/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class Rating {
    let average: String
    let teamwork: String
    let skill: String
    
    init(average: String, teamwork: String, skill: String) {
        self.average = average
        self.teamwork = teamwork
        self.skill = skill
    }
}
