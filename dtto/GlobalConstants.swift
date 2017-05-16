//
//  GlobalConstants.swift
//  dtto
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
let defaults = UserDefaults.standard


// Firebase
let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()
let POSTS_REF = FIREBASE_REF.child("posts")
let CHATS_REF = FIREBASE_REF.child("chats")
let USERS_REF = FIREBASE_REF.child("users")
let MESSAGES_REF = FIREBASE_REF.child("messages")
let POSTRELATES_REF = FIREBASE_REF.child("postRelates")
let REQUESTS_REF = FIREBASE_REF.child("requests")
let COMMENTS_REF = FIREBASE_REF.child("comments")
let REPORTS_REF = FIREBASE_REF.child("reports")
let PROFILES_REF = FIREBASE_REF.child("profiles")

let POSTS_CHILD = "posts"
let CHATS_CHILD = "chats"
let USERS_CHILD = "users"
let MESSAGES_CHILD = "messages"
let FOLLOWERS_CHILD = "followers"

let FIREBASE_TIMESTAMP = [".sv" : "timestamp"]

// Screen Sizes
var SCREENORIENTATION: UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}

var SCREENWIDTH: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.width
    } else {
        return UIScreen.main.bounds.size.height
    }
}
var SCREENHEIGHT: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.height
    } else {
        return UIScreen.main.bounds.size.width
    }
}

// Colors
enum Color {
    
    static let salmon = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0) // #EBA5A0
    static let darkSalmon = UIColor(red:0.82, green:0.24, blue:0.32, alpha:1.0)
    static let lightGray = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)
    static let lightGreen = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0) 
    static let textGray = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)   // #888888
    static let gray247 = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)    // #f7f7f7
    static let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
    static let darkNavy = UIColor(red:0.18, green:0.22, blue:0.29, alpha:1.0) //#2D394B
}
