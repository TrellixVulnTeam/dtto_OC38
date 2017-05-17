//
//  Relater.swift
//  dtto
//
//  Created by Jitae Kim on 2/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

class Relater {
    
    let userID: String
    let username: String
    let name: String
    let timestamp: Date
    
    init?(snapshot: FIRDataSnapshot) {
        
        guard let dictionary = snapshot.value as? [String:Any] else { return nil }
        
        guard let username = dictionary["username"] as? String, let name = dictionary["name"] as? String, let timestamp = dictionary["timestamp"] as? TimeInterval else { return nil }
        
        self.userID = snapshot.key
        self.username = username
        self.name = name
        self.timestamp = Date(timeIntervalSince1970: timestamp/1000)
        
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getName() -> String {
        return name
    }
    
    func getTimestamp() -> Date {
        return timestamp
    }
    
}
