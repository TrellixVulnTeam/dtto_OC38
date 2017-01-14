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
    var username: String?
    var gender: String?
    var age: Int?
    var email: String?
    
    var education = [String]()
    var profession = [String]()
    var expertise = [String]()
    var summary: String?
    
    var answerCount: Int?
    var ongoingChatCount: Int?
    var totalChatCount: Int?
    var relatesReceivedCount: Int?

}
