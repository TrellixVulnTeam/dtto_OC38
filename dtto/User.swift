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
    var birthday: String?
    var email: String?
    
    var education = [String]()
    var profession = [String]()
    var expertise = [String]()
    var summary: String?
    
    var answerCount: Int?
    var ongoingChatCount: Int?
    var totalChatCount: Int?
    var relatesReceivedCount: Int?
    
    func createUserDict() -> [String : Any] {
        
        var userUpdates = [String : Any]()
        
        if let uid = uid {
            userUpdates.updateValue(uid, forKey: "uid")
        }
        
        if let name = name {
            userUpdates.updateValue(name, forKey: "name")
        }
        
        if let username = username {
            userUpdates.updateValue(username, forKey: "username")
        }
        
        if let birthday = birthday {
            userUpdates.updateValue(birthday, forKey: "birthday")
        }
        
        if let email = email {
            userUpdates.updateValue(email, forKey: "email")
        }
        
        if education.count != 0 {
            for (index, education) in education.enumerated() {
                userUpdates.updateValue(index, forKey: education)
            }
        }
        
        if profession.count != 0 {
            for (index, profession) in profession.enumerated() {
                userUpdates.updateValue(index, forKey: profession)
            }
        }
        
        if let summary = summary {
            userUpdates.updateValue(summary, forKey: "summary")
        }
        
        return userUpdates
    }

}
