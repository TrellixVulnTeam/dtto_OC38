//
//  Comments.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//


import Firebase

class Comment {

    var commentID: String
    var userID: String
    var username: String
    var text: String
    var timestamp: Date
    var editTimestamp: Date?
    
    var profileImageURL: String?
    var replies: [Comment]?
    
    var commentRef: FIRDatabaseReference
    
    init?(snapshot: FIRDataSnapshot) {
        
        self.commentID = snapshot.key
        commentRef = snapshot.ref
        
        guard let dictionary = snapshot.value as? [String:AnyObject] else { return nil }
        guard let userID = dictionary["userID"] as? String, let username = dictionary["username"] as? String, let text = dictionary["text"] as? String, let timestamp = dictionary["timestamp"] as? TimeInterval else { return nil }
        
        self.userID = userID
        self.username = username
        self.text = text
        self.timestamp = Date(timeIntervalSince1970: timestamp/1000)
        
        // check if this was edited
        if let editTimestamp = dictionary["editTimestamp"] as? TimeInterval {
            self.editTimestamp = Date(timeIntervalSince1970: editTimestamp/1000)
        }
        // check if there are replies to this comment
        
        if let replies = dictionary["replies"] as? [String: AnyObject] {
            // append each reply to this array.
        }

    }
    
    func getCommentID() -> String {
        return commentID
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getText() -> String {
        return text
    }
    
    func getTimestamp() -> Date {
        return timestamp
    }
    
    func getEditTimestamp() -> Date? {
        return editTimestamp
    }
    
    func getReplies() -> [Comment]? {
        return replies
    }
    
    func getCommentRef() -> FIRDatabaseReference {
        return commentRef
    }

    
}
