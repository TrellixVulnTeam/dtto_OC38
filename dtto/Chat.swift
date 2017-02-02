//
//  Chat.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

class Chat: NSObject {
    
    var chatID: String?
    var senderID: String?
    var name: String?
    var lastMessage: String?
    var timestamp: String?
    var profileImageURL: String?
    var postID: String?
    
    init(snapshot: FIRDataSnapshot) {
        super.init()
        
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
        
        guard let userID = defaults.getUID(), let users = dictionary["users"] as? Dictionary<String, AnyObject>, let postID = dictionary["postID"] as? String else { return }
        
        for user in users {
            // get the other user's information
            if user.key != userID {
                
                if let friendName = user.value as? String {
                    name = friendName
                }
                
            }
        }
        
        self.chatID = snapshot.key
        self.postID = postID
        
        if let senderID = dictionary["senderID"] as? String, let lastMessage = dictionary["text"] as? String!, let timestamp = dictionary["timestamp"] as? String {
            
            self.senderID = senderID
            self.lastMessage = lastMessage
            
            //                    let cal = Calendar(identifier: .gregorian)
            //                    let c = Calendar.current
            //                    let current = c.startOfDay(for: Date())
            let currentDate = Date()
            let timestampDate = stringToDate(timestamp)
            
            
            // just show hours and minutes.
            
            self.timestamp = timestamp
            
        }

    }
    
}
