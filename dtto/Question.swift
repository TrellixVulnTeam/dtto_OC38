//
//  Question.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

class Question: NSObject {
    
    var questionID: String?
    var userID: String?
    var name: String?
    var displayName: String?
    var text: String?
    var profileImageURL: String?
    var category: String?
    var chatCount: Int?
    var relateCount: Int?
    var tags: String?
    var isAnonymous: Bool = false
    
}
