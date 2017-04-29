//
//  Notification.swift
//  dtto
//
//  Created by Jitae Kim on 12/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

class UserNotification {
    
    var senderID: String
    var postID: String
    var senderName: String
    var profileImageURL: String?
    var timestamp: String?
    var notificationID: String
    
    init?(snapshot: FIRDataSnapshot) {
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return nil }
        
        guard let postID = dictionary["postID"] as? String, let senderID = dictionary["senderID"] as? String, let senderName = dictionary["senderName"] as? String, let timestamp = dictionary["timestamp"] as? String else { return nil }
        
        self.postID = postID
        self.senderID = senderID
        self.senderName = senderName
        self.timestamp = timestamp
        self.notificationID = snapshot.key
    }
    
    func getSenderID() -> String {
        return senderID
    }
    
    func getPostID() -> String {
        return postID
    }
    
    func getSenderName() -> String {
        return senderName
    }
    
    func getNotificationID() -> String {
        return notificationID
    }
}
