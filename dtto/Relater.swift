//
//  Relater.swift
//  dtto
//
//  Created by Jitae Kim on 2/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation

class Relater {
    
    let userID: String?
    let username: String?
    let name: String?
    let timestamp: String?
    
    init(dictionary: [String: AnyObject]) {
        
        userID = dictionary.keys.first
        username = dictionary["username"] as? String
        name = dictionary["name"] as? String
        timestamp = dictionary["timestamp"] as? String
        
    }
    
}
