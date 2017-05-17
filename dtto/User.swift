//
//  User.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

class User: NSObject {
    
    var uid: String
    var name: String
    var username: String
    var gender: String?
    var birthday: String?
    var email: String?
    var location: String?
    
    var summary: String?
    var education = [String]()
    var profession = [String]()
    var expertise = [String]()
    
    var helpfulCount: Int
    var postCount: Int
    var profileViewCount: Int
    var relatesReceivedCount: Int
    
    
    init?(snapshot: FIRDataSnapshot) {
    
        self.uid = snapshot.key
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return nil }
        guard let username = dictionary["username"] as? String, let name = dictionary["name"] as? String else { return nil }
        
        self.username = username
        self.name = name
        
        self.helpfulCount = dictionary["helpfulCount"] as? Int ?? 0
        self.postCount = dictionary["postCount"] as? Int ?? 0
        self.profileViewCount = dictionary["profileViewCount"] as? Int ?? 0
        self.relatesReceivedCount = dictionary["relatesReceivedCount"] as? Int ?? 0
    
    }
    
    func getUserID() -> String {
        return uid
    }
    
    func getName() -> String {
        return name
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getSummary() -> String? {
        return summary
    }
    
    func getHelpfulCount() -> Int {
        return helpfulCount
    }
    
    func getPostCount() -> Int {
        return postCount
    }
    
    func getProfileViewCount() -> Int {
        return profileViewCount
    }
    
    func getRelatesReceivedCount() -> Int {
        return relatesReceivedCount
    }

    
    func createUserDict() -> [String : Any] {
        
        let userUpdates = [String : Any]()
        
//        if let uid = uid {
//            userUpdates.updateValue(uid, forKey: "uid")
//        }
//        
//        if let name = name {
//            userUpdates.updateValue(name, forKey: "name")
//        }
//        
//        if let username = username {
//            userUpdates.updateValue(username, forKey: "username")
//        }
//        
//        if let birthday = birthday {
//            userUpdates.updateValue(birthday, forKey: "birthday")
//        }
//        
//        if let email = email {
//            userUpdates.updateValue(email, forKey: "email")
//        }
//        
//        if let location = location {
//            userUpdates.updateValue(location, forKey: "location")
//        }
//        
//        if education.count != 0 {
//            for (index, education) in education.enumerated() {
//                userUpdates.updateValue(index, forKey: education)
//            }
//        }
//        
//        if profession.count != 0 {
//            for (index, profession) in profession.enumerated() {
//                userUpdates.updateValue(index, forKey: profession)
//            }
//        }
//        
//        if let summary = summary {
//            userUpdates.updateValue(summary, forKey: "summary")
//        }
        
        return userUpdates
    }

}


class NewUser: NSObject {
    
    var uid: String?
    var name: String?
    var username: String?
    var email: String?
}
