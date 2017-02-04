//
//  UserDefaults.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setLogin(value: Bool) {
        set(value, forKey: "loggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "loggedIn")
    }
    
    func setUID(value: String) {
        set(value, forKey: "uid")
    }
    
    func getUID() -> String? {
        return string(forKey: "uid")
    }
    
    func setName(value: String) {
        set(value, forKey: "name")
    }
    
    func getName() -> String? {
        return string(forKey: "name")
    }
    
    func setUsername(value: String) {
        set(value, forKey: "username")
    }
    
    func getUsername() -> String? {
        return string(forKey: "username")
    }
    
    func setOutgoingRequests(value: [String : Bool]) {
        set(value, forKey: "outgoingRequests")
    }
    
    func getOutgoingRequests() -> [String : Bool] {
        return object(forKey: "outgoingRequests") as? [String : Bool] ?? [String : Bool]()
    }
    
    func hidePost(postID: String) {
        var hiddenPosts = getHiddenPosts()
        hiddenPosts.updateValue(true, forKey: postID)
        set(hiddenPosts, forKey: "hiddenPosts")
    }
    
    func getHiddenPosts() -> [String : Bool] {
        return object(forKey: "hiddenPosts") as? [String : Bool] ?? [String : Bool]()
    }
    
    func setRecent(value: [String]) {
        set(value, forKey: "recent")
    }
    
    func getRecent() -> [String] {
        return object(forKey: "recent") as? [String] ?? [String]()
    }
    
    func setLikes(value: [String]) {
        set(value, forKey: "likes")
    }
    
    func getLikes() -> [String]{
        return object(forKey: "likes") as? [String] ?? [String]()
    }
    
    func setFavorites(value: [String]) {
        set(value, forKey: "favorites")
    }
    
    func getFavorites() -> [String] {
        return object(forKey: "favorites") as? [String] ?? [String]()
    }

    
    func updateVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            set(version, forKey: "version")
        }
    }
    
    func getStoredVersion() -> String? {
        return object(forKey: "version") as? String

    }
    
    func getCurrentVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? nil
    }
    
    // MARK - App Rating
    func getAppLaunchCount() -> Int {
        return integer(forKey: "numberOfLaunches")
    }
    
    func setAppLaunches(value: Int) {
        set(value, forKey: "numberOfLaunches")
    }
    
    func hasShownRating() -> Bool {
        return bool(forKey: "hasShownRating")
    }
    
    func setShownRating(value: Bool) {
        set(value, forKey: "hasShownRating")
    }
    
    
}
