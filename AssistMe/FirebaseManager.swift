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
    private let messageItem = "messageItem"
    private let text = "text"
    private let date = "date"
    private let sender = "sender"
    private let notification = "notification"
    private let rating = "rating"
    private let ratingCount = "ratingCount"
    private let averageRating = "averageRating"
    private let skillRating = "skillRating"
    private let teamworkRating = "teamworkRating"
    private let jobListing = "job-listing"
    private let description = "description"
    private let jobTitle = "jobTitle"
    private let uid = "uid"
    private let skillsListing = "skills-listing"
    private let skillOne = "skillOne"
    private let skillTwo = "skillTwo"
    private let skillThree = "skillThree"
    private let skillFour = "skillFour"
    private let myJob = "myJob"
    private let acceptDate = "acceptDate"
    private let active = "active"
    private let request = "request"
    private let jobKey = "jobKey"
    private let requestDate = "requestDate"
    private let partnerDisplayName = "partnerDisplayName"
    
    private let rootNodeRef = FIRDatabase.database().reference()
    private let profileNodeRef: FIRDatabaseReference
    private let jobListingNodeRef: FIRDatabaseReference
    private let skillsListingNodeRef: FIRDatabaseReference
    
    private init() {
        profileNodeRef = rootNodeRef.child(profile)
        jobListingNodeRef = rootNodeRef.child(jobListing)
        skillsListingNodeRef = rootNodeRef.child(skillsListing)
    }
    
    // MARK: - Authentication functions
    
    func addStateListener(listenerBlock: @escaping (FIRUser?) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener { _, user in
            self.currentUser = user
            listenerBlock(user)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            self.currentUser = user
            completion(error)
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
    
    func addUser(byUid uid: String, displayName: String) {
        let uidNodeRef = profileNodeRef.child(uid)
        
        // displayname rating skills
        let profileContent: [String: Any] = [
            self.displayName: displayName,
            self.rating: [
                self.ratingCount: "0",
                self.averageRating: "0",
                self.teamworkRating: "0",
                self.skillRating: "0"
            ]
        ]
        
        uidNodeRef.setValue(profileContent)
    }
    
    func sendMessage(toUID uid: String, displayName: String, text: String, date: String) {
        var keyNodeRef: FIRDatabaseReference
        var displayNameNodeRef: FIRDatabaseReference
        var lastTextDateNodeRef: FIRDatabaseReference
        var messageItemNodeRef: FIRDatabaseReference
        
        let messageItem = [
            self.text: text,
            self.date: date,
            self.sender: currentUser!.uid
        ]
                
        // Add to receiver's received node
        messageItemNodeRef = messageNodeRef(uid: uid).child(messageItemPath(uid: currentUser!.uid))
        keyNodeRef = messageItemNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
        // Update last text date for receiver
        lastTextDateNodeRef = messageNodeRef(uid: uid).child(lastTextDatePath(uid: currentUser!.uid))
        lastTextDateNodeRef.setValue(date)
        // Update sender's display name for receiver
        displayNameNodeRef = messageNodeRef(uid: uid).child(displayNamePath(uid: currentUser!.uid))
        displayNameNodeRef.setValue(currentUser!.displayName)
        
        // Add to senders's sent node
        messageItemNodeRef = messageNodeRef(uid: currentUser!.uid).child(messageItemPath(uid: uid))
        keyNodeRef = messageItemNodeRef.childByAutoId()
        keyNodeRef.setValue(messageItem)
        // Update last text date for sender
        lastTextDateNodeRef = messageNodeRef(uid: currentUser!.uid).child(lastTextDatePath(uid: uid))
        lastTextDateNodeRef.setValue(date)
        // Update receiver's display name for sender
        displayNameNodeRef = messageNodeRef(uid: currentUser!.uid).child(displayNamePath(uid: uid))
        displayNameNodeRef.setValue(displayName)
    }
    
    func queryMessages(completion: @escaping (Message) -> Void) {
        query(forNodeRef: messageNodeRef(uid: currentUser!.uid), observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let uid = snapshot.key
            guard let displayName = properties[self.displayName] as? String else {
                return
            }
            guard let lastTextDate = properties[self.lastTextDate] as? String else {
                return
            }
            let message = Message(uid: uid, displayName: displayName, date: lastTextDate)
            
            completion(message)
        }
    }
    
    func updateMessages(completion: @escaping (Message) -> Void) {
        query(forNodeRef: messageNodeRef(uid: currentUser!.uid), observationType: .childChanged) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let uid = snapshot.key
            let displayName = properties[self.displayName] as! String
            let lastTextDate = properties[self.lastTextDate] as! String
            let message = Message(uid: uid, displayName: displayName, date: lastTextDate)
            
            completion(message)
        }
    }
    
    func queryMessageItems(forUID uid: String, messageItemHandler: @escaping (Message) -> Void) {
        let messageItemNodeRef = messageNodeRef(uid: currentUser!.uid).child(messageItemPath(uid: uid))
        
        query(forNodeRef: messageItemNodeRef, observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let senderUID = properties[self.sender] as! String
            let date = properties[self.date] as! String
            let text = properties[self.text] as! String
            
            let messageItem = Message(uid: senderUID, date: date, text: text)
            
            messageItemHandler(messageItem)
        }
    }
    
    func postJobListing(date: String, description: String, jobTitle: String) {
        let jobListing = [
            self.date : date,
            self.description: description,
            self.jobTitle: jobTitle,
            self.uid: currentUser!.uid
        ]
        
        let newJobListingRef = jobListingNodeRef.childByAutoId()
        newJobListingRef.setValue(jobListing)
    }
    
    func queryJobListings(jobHandler: @escaping (Job) -> Void) {
        query(forNodeRef: jobListingNodeRef, observationType: .childAdded) { snapshot in
            let jobKey = snapshot.key
            let properties = snapshot.value as! NSDictionary
            let date = properties[self.date] as! String
            let description = properties[self.description] as! String
            let jobTitle = properties[self.jobTitle] as! String
            let uid = properties[self.uid] as! String
            
            self.query(forUID: uid) { snapshot in
                let profile = snapshot.value as! NSDictionary
                let displayName = profile[self.displayName] as! String
                let rating = profile[self.rating] as! NSDictionary
                let averageRating = rating[self.averageRating] as! String
                let teamworkRating = rating[self.teamworkRating] as! String
                let skillRating = rating[self.skillRating] as! String
                
                let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                let job = Job(key: jobKey, uid: uid, displayName: displayName, date: date, description: description, title: jobTitle, rating: userRating)
                
                jobHandler(job)
            }
        }
    }
    
    func queryJobListings(forUID uid: String, jobHandler: @escaping (Job) -> Void) {
        query(forNodeRef: jobListingNodeRef, forUID: uid) { snapshot in
            let jobKey = snapshot.key
            let properties = snapshot.value as! NSDictionary
            let description = properties[self.description] as! String
            let jobTitle = properties[self.jobTitle] as! String
            let date = properties[self.date] as! String
            
            self.query(forUID: uid) { snapshot in
                let profile = snapshot.value as! NSDictionary
                let displayName = profile[self.displayName] as! String
                let rating = profile[self.rating] as! NSDictionary
                let averageRating = rating[self.averageRating] as! String
                let teamworkRating = rating[self.teamworkRating] as! String
                let skillRating = rating[self.skillRating] as! String
                
                let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                let job = Job(key: jobKey, uid: uid, displayName: displayName, date: date, description: description, title: jobTitle, rating: userRating)
                
                jobHandler(job)
            }
        }
    }
    
    func postSkillsListing(date: String, skillOne: String, skillTwo: String, skillThree: String, skillFour: String) {
        let skillsListing = [
            self.date : date,
            self.skillOne: skillOne,
            self.skillTwo: skillTwo,
            self.skillThree: skillThree,
            self.skillFour: skillFour,
            self.uid: currentUser!.uid
        ]
        
        let newSkillsListing = skillsListingNodeRef.childByAutoId()
        newSkillsListing.setValue(skillsListing)
    }
    
    func querySkillListings(completion: @escaping (Skill) -> Void) {
        query(forNodeRef: skillsListingNodeRef, observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let date = properties[self.date] as! String
            let skillOne = properties[self.skillOne] as! String
            let skillTwo = properties[self.skillTwo] as! String
            let skillThree = properties[self.skillThree] as! String
            let skillFour = properties[self.skillFour] as! String
            let uid = properties[self.uid] as! String
            
            self.query(forUID: uid) { snapshot in
                let profile = snapshot.value as! NSDictionary
                let displayName = profile[self.displayName] as! String
                let rating = profile[self.rating] as! NSDictionary
                let averageRating = rating[self.averageRating] as! String
                let teamworkRating = rating[self.teamworkRating] as! String
                let skillRating = rating[self.skillRating] as! String
                
                let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                let skill = Skill(uid: uid, displayName: displayName, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour, date: date, rating: userRating)
                
                completion(skill)
            }
        }
    }
    
    func querySkillsListings(forUID uid: String, skillHandler: @escaping (Skill) -> Void) {
        query(forNodeRef: skillsListingNodeRef, forUID: uid) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let skillOne = properties[self.skillOne] as! String
            let skillTwo = properties[self.skillTwo] as! String
            let skillThree = properties[self.skillThree] as! String
            let skillFour = properties[self.skillFour] as! String
            let date = properties[self.date] as! String
            
            self.query(forUID: uid) { snapshot in
                let profile = snapshot.value as! NSDictionary
                let displayName = profile[self.displayName] as! String
                let rating = profile[self.rating] as! NSDictionary
                let averageRating = rating[self.averageRating] as! String
                let teamworkRating = rating[self.teamworkRating] as! String
                let skillRating = rating[self.skillRating] as! String
                
                let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                let skill = Skill(uid: uid, displayName: displayName, skillOne: skillOne, skillTwo: skillTwo, skillThree: skillThree, skillFour: skillFour, date: date, rating: userRating)
                
                skillHandler(skill)
            }
        }
    }
    
    func sendRequest(toUID uid: String, partnerDisplayName: String, job: Job, requestDate: String) {
        let requestItemNodeRef = profileNodeRef.child(requestPath(uid: uid)).childByAutoId()
        
        let requestContent: [String: String] = [
            self.partnerDisplayName: partnerDisplayName,
            self.displayName: job.displayName,
            self.jobKey: job.key,
            self.jobTitle: job.title,
            self.requestDate: requestDate
        ]
        
        requestItemNodeRef.setValue(requestContent)
    }
    
    func queryRequests(requestHandler: @escaping (JobRequest) -> ()) {
        let requestNodeRef = profileNodeRef.child(requestPath(uid: currentUser!.uid))
        
        query(forNodeRef: requestNodeRef, observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let partnerDisplayName = properties[self.partnerDisplayName] as! String
            let displayName = properties[self.displayName] as! String
            let jobTitle = properties[self.jobTitle] as! String
            let requestDate = properties[self.requestDate] as! String
            let jobKey = properties[self.jobKey] as! String
            
            self.query(forJobKey: jobKey) { snapshot in
                let properties = snapshot.value as! NSDictionary
                let description = properties[self.description] as! String
                let date = properties[self.date] as! String
                let uid = properties[self.uid] as! String
                
                self.query(forUID: uid) { snapshot in
                    let profile = snapshot.value as! NSDictionary
                    let rating = profile[self.rating] as! NSDictionary
                    let averageRating = rating[self.averageRating] as! String
                    let teamworkRating = rating[self.teamworkRating] as! String
                    let skillRating = rating[self.skillRating] as! String
                    
                    let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                    let job = Job(key: jobKey, uid: uid, displayName: displayName, date: date, description: description, title: jobTitle, rating: userRating)
                    let jobRequest = JobRequest(partnerDisplayName: partnerDisplayName, displayName: displayName, jobTitle: jobTitle, requestDate: requestDate, job: job)
                    
                    requestHandler(jobRequest)
                }
            }
        }
    }
    
    func acceptJobRequest(jobRequest: JobRequest) {
        var myJobItemNodeRef: FIRDatabaseReference
        var myJobContent: [String: String]
        
        myJobContent = [
            self.acceptDate: jobRequest.acceptDate,
            self.active: jobRequest.active,
            self.displayName: jobRequest.displayName,
            self.jobKey: jobRequest.job.key,
            self.jobTitle: jobRequest.jobTitle,
            self.partnerDisplayName: jobRequest.partnerDisplayName
        ]
        
        myJobItemNodeRef = profileNodeRef.child(myJobPath(uid: currentUser!.uid)).childByAutoId()
        myJobItemNodeRef.setValue(myJobContent)
        
        myJobContent = [
            self.acceptDate: jobRequest.acceptDate,
            self.active: jobRequest.active,
            self.displayName: jobRequest.displayName,
            self.jobKey: jobRequest.job.key,
            self.jobTitle: jobRequest.jobTitle,
            self.partnerDisplayName: currentUser!.displayName!
        ]
        
        let jobOwnerUID = jobRequest.job.uid
        myJobItemNodeRef = profileNodeRef.child(myJobPath(uid: jobOwnerUID)).childByAutoId()
        myJobItemNodeRef.setValue(myJobContent)
    }
    
    func queryMyJobs(myJobHandler: @escaping (JobRequest) -> Void) {
        let myJobItemNodeRef = profileNodeRef.child(myJobPath(uid: currentUser!.uid))
        
        query(forNodeRef: myJobItemNodeRef, observationType: .childAdded) { snapshot in
            let properties = snapshot.value as! NSDictionary
            let myJobKey = snapshot.key
            let partnerDisplayName = properties[self.partnerDisplayName] as! String
            let displayName = properties[self.displayName] as! String
            let jobTitle = properties[self.jobTitle] as! String
            let acceptDate = properties[self.acceptDate] as! String
            let jobKey = properties[self.jobKey] as! String
            let active = properties[self.active] as! String
            
            self.query(forJobKey: jobKey) { snapshot in
                let properties = snapshot.value as! NSDictionary
                let description = properties[self.description] as! String
                let date = properties[self.date] as! String
                let uid = properties[self.uid] as! String
                
                self.query(forUID: uid) { snapshot in
                    let profile = snapshot.value as! NSDictionary
                    let rating = profile[self.rating] as! NSDictionary
                    let averageRating = rating[self.averageRating] as! String
                    let teamworkRating = rating[self.teamworkRating] as! String
                    let skillRating = rating[self.skillRating] as! String
                    
                    let userRating = Rating(average: averageRating, teamwork: teamworkRating, skill: skillRating)
                    let job = Job(key: jobKey, uid: uid, displayName: displayName, date: date, description: description, title: jobTitle, rating: userRating)
                    let jobRequest = JobRequest(partnerDisplayName: partnerDisplayName, displayName: displayName, jobTitle: jobTitle, acceptDate: acceptDate, active: active, myJobKey: myJobKey, job: job)
                    
                    myJobHandler(jobRequest)
                }
            }
            
        }
    }
    
    func closeMyJob(jobRequest: JobRequest) {
        let myJobContent = [
            self.acceptDate: jobRequest.acceptDate,
            self.active: jobRequest.active,
            self.displayName: jobRequest.displayName,
            self.jobKey: jobRequest.job.key,
            self.jobTitle: jobRequest.jobTitle,
            self.partnerDisplayName: jobRequest.partnerDisplayName
        ]
        
        let myJobItem = profileNodeRef.child("\(myJobPath(uid: currentUser!.uid))/\(jobRequest.myJobKey)")
        myJobItem.setValue(myJobContent)
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
    
    // uid/messageItem
    private func messageItemPath(uid: String) -> String {
        return "\(uid)/\(messageItem)"
    }
    
    // uid/request
    private func requestPath(uid: String) -> String {
        return "\(uid)/\(request)"
    }
    
    // uid/myJob
    private func myJobPath(uid: String) -> String {
        return "\(uid)/\(myJob)"
    }
    
    private func uidNodeRef(uid: String) -> FIRDatabaseReference {
        return profileNodeRef.child(uid)
    }
    
    private func messageNodeRef(uid: String) -> FIRDatabaseReference {
        let messagePath = "\(uid)/\(message)"
        return profileNodeRef.child(messagePath)
    }
    
    private func query(forNodeRef nodeRef: FIRDatabaseReference, observationType: FIRDataEventType, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = nodeRef.queryLimited(toLast: 25)
        query.observe(observationType) { snapshot in
            snapshotHandler(snapshot)
        }        
    }
    
    private func query(forUID uid: String, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = profileNodeRef.queryEqual(toValue: nil, childKey: uid)
        query.observeSingleEvent(of: .childAdded) { snapshot in
            snapshotHandler(snapshot)
        }
    }
    
    private func query(forNodeRef nodeRef: FIRDatabaseReference, forUID uid: String, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = nodeRef.queryOrdered(byChild: self.uid).queryEqual(toValue: uid)
        query.observe(.childAdded) { snapshot in
            snapshotHandler(snapshot)
        }
    }
    
    private func query(forJobKey key: String, snapshotHandler: @escaping (FIRDataSnapshot) -> Void) {
        let query = jobListingNodeRef.queryEqual(toValue: nil, childKey: key)
        query.observeSingleEvent(of: .childAdded) { snapshot in
            snapshotHandler(snapshot)
        }
    }
}
