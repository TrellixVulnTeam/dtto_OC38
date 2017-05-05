//
//  Notification.swift
//  dtto
//
//  Created by Jitae Kim on 12/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Firebase

enum NotificationType: String {
    case relate
    case resolve
}

class UserNotification {
    
    var senderID: String
    var postID: String?
    var senderName: String
    var profileImageURL: String?
    var timestamp: String
    var notificationID: String
    var autoID: String
    var chatID: String?
    var notificationType: NotificationType
    
    init?(snapshot: FIRDataSnapshot) {
        
        autoID = snapshot.key
        
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return nil }
        
        guard let senderID = dictionary["senderID"] as? String, let senderName = dictionary["senderName"] as? String, let timestamp = dictionary["timestamp"] as? TimeInterval else { return nil }
        
        if let postID = dictionary["postID"] as? String {
            self.postID = postID
        }
        
        if let chatID = dictionary["chatID"] as? String {
            self.chatID = chatID
        }
        
        self.senderID = senderID
        self.senderName = senderName
        self.timestamp = Date(timeIntervalSince1970: timestamp/1000).timeAgoSinceDate(numericDates: true)
        self.notificationID = snapshot.key
        self.notificationType = NotificationType(rawValue: dictionary["type"] as? String ?? "relate") ?? .relate
    }
    
    func getAutoID() -> String {
        return autoID
    }
    
    func getSenderID() -> String {
        return senderID
    }
    
    func getPostID() -> String? {
        return postID
    }
    
    func getSenderName() -> String {
        return senderName
    }
    
    func getNotificationID() -> String {
        return notificationID
    }
    
    func getChatID() -> String? {
        return chatID
    }
    
    func getNotificationType() -> NotificationType {
        return notificationType
    }
    
    func getTime() -> String {
        return timestamp
    }
}
