//
//  Chat.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

class Chat {
    
    let chatID: String
    var senderID: String?
    var name: String?
    var lastMessage: String?
    var timestamp: String?
    var profileImageURL: String?
    let postID: String
    let helperID: String
    let posterID: String
    
    init?(snapshot: FIRDataSnapshot) {
        
        chatID = snapshot.key

        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return nil }
        
        guard let postID = dictionary["postID"] as? String, let helperID = dictionary["helperID"] as? String, let posterID = dictionary["posterID"] as? String else { return nil }
        // , let users = dictionary["users"] as? Dictionary<String, AnyObject>
//        for user in users {
//            // get the other user's information
//            if user.key != userID {
//                
//                if let friendName = user.value as? String {
//                    name = friendName
//                    friendID = user.key
//                }
//                
//            }
//        }

        self.postID = postID
        self.posterID = posterID
        self.helperID = helperID
        
        if let senderID = dictionary["senderID"] as? String, let lastMessage = dictionary["text"] as? String!, let timestamp = dictionary["timestamp"] as? String {
            
            self.senderID = senderID
            self.lastMessage = lastMessage
            
//            let cal = Calendar(identifier: .gregorian)
//            let c = Calendar.current
//            let current = c.startOfDay(for: Date())
            let currentDate = Date()
//            let timestampDate = stringToDate(timestamp)
            
            
            // just show hours and minutes.
            
            self.timestamp = timestamp
            
        }

    }
    
    func getChatID() -> String {
        return chatID
    }
    
    func getPostID() -> String {
        return postID
    }
    
    func getPosterID() -> String {
        return posterID
    }
    
    func getHelperID() -> String {
        return helperID
    }
    
    func getFriendID() -> String {
        
        let userID = defaults.getUID()
        if userID == posterID {
            return helperID
        }
        else {
            return posterID
        }
    }
    
    func getLastMessage() -> String {
        return lastMessage ?? ""
    }
    
    func getTimestamp() -> String? {
        return timestamp
    }
    
}
