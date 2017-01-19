//
//  Post.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

class Post: NSObject {
    
    var postID: String?
    var userID: String?
    var name: String = ""
    var username: String?
    var text: String?
    var profileImageURL: String?
    var category: String?
    var chatCount: Int?
    var relatesCount: Int?
    var tags: String?
    var isAnonymous: Bool = false
    
//    init(dictionary: [String: AnyObject]) {
//        super.init()
//        
//        postID = dictionary["postID"] as? String
//        userID = dictionary["userID"] as? String
//        text = dictionary["text"] as? String
//        chatCount = dictionary["chatCount"] as? Int
//        relatesCount = dictionary["relatesCount"] as? Int
//        
//    }
    
}
