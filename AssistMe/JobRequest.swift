//
//  JobRequest.swift
//  AssistMe
//
//  Created by Charles Gong on 11/21/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import Foundation

class JobRequest {
//    let requesteeDisplayName: String
//    let requesteeUID: String
    
    let partnerDisplayName: String
    let displayName: String
    let jobTitle: String
    let requestDate: String
    var acceptDate: String
    var active: String
    var myJobKey: String
    let job: Job
    
    init(partnerDisplayName: String, displayName: String, jobTitle: String, requestDate: String, acceptDate: String, active: String, myJobKey: String, job: Job) {
        self.partnerDisplayName = partnerDisplayName
        self.displayName = displayName
        self.jobTitle = jobTitle
        self.requestDate = requestDate
        self.acceptDate = acceptDate
        self.active = active
        self.myJobKey = myJobKey
        self.job = job
    }
    
    convenience init(partnerDisplayName: String, displayName: String, jobTitle: String, requestDate: String, job: Job) {
        self.init(partnerDisplayName: partnerDisplayName, displayName: displayName, jobTitle: jobTitle, requestDate: requestDate, acceptDate: "", active: "", myJobKey: "", job: job)
    }
    
    convenience init(partnerDisplayName: String, displayName: String, jobTitle: String, acceptDate: String, active: String, myJobKey: String, job: Job) {
        self.init(partnerDisplayName: partnerDisplayName, displayName: displayName, jobTitle: jobTitle, requestDate: "", acceptDate: acceptDate, active: active, myJobKey: myJobKey, job: job)
    }
}
