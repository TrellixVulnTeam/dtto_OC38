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
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "loggedIn")
    }
    
    func setUID(value: String) {
        set(value, forKey: "uid")
        synchronize()
    }
    
    func getUID() -> String? {
        return string(forKey: "uid")
    }
    
    func setName(value: String) {
        set(value, forKey: "name")
        synchronize()
    }
    
    func getName() -> String? {
        return string(forKey: "name")
    }
    func setEditPermissions(value: Bool) {
        set(value, forKey: "edit")
        synchronize()
    }
    
    func canEdit() -> Bool {
        return bool(forKey: "edit")
    }
    
    func setAbilityIndex(value: Int) {
        set(value, forKey: "abilityIndex")
        synchronize()
    }
    
    func abilityIndex() -> Int {
        return integer(forKey: "abilityIndex")
    }
    
    func setRecent(value: [String]) {
        set(value, forKey: "recent")
        synchronize()
    }
    
    func getRecent() -> [String] {
        return object(forKey: "recent") as? [String] ?? [String]()
    }
    
    func setLikes(value: [String]) {
        set(value, forKey: "likes")
        synchronize()
    }
    
    func getLikes() -> [String]{
        return object(forKey: "likes") as? [String] ?? [String]()
    }
    
    func setFavorites(value: [String]) {
        set(value, forKey: "favorites")
        synchronize()
    }
    
    func getFavorites() -> [String] {
        return object(forKey: "favorites") as? [String] ?? [String]()
    }
    
    func setImagePermissions(value: Bool) {
        set(value, forKey: "image")
        synchronize()
    }
    
    func getImagePermissions() -> Bool {
        return bool(forKey: "image")
    }
    
    func updateVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            set(version, forKey: "version")
            synchronize()
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
        synchronize()
    }
    
    func hasShownRating() -> Bool {
        return bool(forKey: "hasShownRating")
    }
    
    func setShownRating(value: Bool) {
        set(value, forKey: "hasShownRating")
        synchronize()
    }
    
    
}
