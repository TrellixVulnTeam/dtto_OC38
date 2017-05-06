//
//  swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

class Post {
    
    var postID: String
    var userID: String
    var name: String?
    var username: String?
    var text: String?
    var profileImageURL: String?
    var category: String?
    var chatCount: Int
    let relatesCount: Int
    var commentCount: Int
    var tags: String?
    var isAnonymous: Bool = true
    
    init?(snapshot: FIRDataSnapshot) {
        
        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return nil }
        guard let postID = dictionary["postID"] as? String, let userID = dictionary["userID"] as? String else { return nil }
        self.postID = postID
        self.userID = userID
        
        name = dictionary["name"] as? String
        if let username = dictionary["username"] as? String {
            self.username = username
            isAnonymous = false
        }
        else {
            username = "Anonymous"
        }
        
        text = dictionary["text"] as? String
        
        chatCount = dictionary["chatCount"] as? Int ?? 0
        relatesCount = dictionary["relatesCount"] as? Int ?? 0
        commentCount = dictionary["commentCount"] as? Int ?? 0

        
        if let tags = dictionary["tags"] as? Dictionary<String, AnyObject> {
            for tag in tags {
                self.tags = "\(tags), \(tag.key)"
            }
        }
        
    }
    
    func getPostID() -> String {
        return postID
    }
    
    func getUserID() -> String {
        return userID
    }
    
    func getRelatesCount() -> Int {
        return relatesCount
    }
    
    func getCommentCount() -> Int {
        return commentCount
    }
    
    func getPostUsername() -> String? {
        return username
    }
}
