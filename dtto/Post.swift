//
//  swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

class Post: NSObject {
    
    var postID: String?
    var userID: String?
    var name: String?
    var username: String?
    var text: String?
    var profileImageURL: String?
    var category: String?
    var chatCount: Int?
    var relatesCount: Int?
    var tags: String?
    var isAnonymous: Bool = false
    
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        postID = dictionary["postID"] as? String
        userID = dictionary["userID"] as? String
        
        name = dictionary["name"] as? String
        username = dictionary["username"] as? String
        
        text = dictionary["text"] as? String
        
        chatCount = dictionary["chatCount"] as? Int
        relatesCount = dictionary["relatesCount"] as? Int

        
        if let tags = dictionary["tags"] as? Dictionary<String, AnyObject> {
            for tag in tags {
                self.tags = "\(tags), \(tag.key)"
            }
        }
        
    }
    
}
