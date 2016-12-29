//
//  User.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//


class User: NSObject {
    
    var uid: String?
    var name: String?
    var displayName: String?
    var gender: String?
    
    var education: [String: AnyObject]?
    var profession: String?
    var expertise: [String: AnyObject]?
    var summary: String?
    
    var answerCount: Int?
    var ongoingChatCount: Int?
    var totalChatCount: Int?
    var relateCount: Int?

}
