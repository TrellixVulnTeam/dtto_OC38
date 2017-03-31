//
//  Notifications.swift
//  dtto
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsPage: BaseCollectionViewCell {
    
    var relates = [UserNotification]()
    var requests = [UserNotification]()
    var initialLoad = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        observeNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        
    }

    private func observeNotifications() {
        
        print("Getting notifications...")
        guard let userID = defaults.getUID() else { return }
        
        let notificationsRef = FIREBASE_REF.child("relatesNotifications").child(userID)
        notificationsRef.observe(.childAdded, with: { snapshot in

            guard let userNotifications = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            guard let uid = userNotifications["uid"] as? String, let name = userNotifications["name"] as? String, let postID = userNotifications["postID"] as? String, let timestamp = userNotifications["timestamp"] as? String else { return }
            
            let notification = UserNotification()
            
            notification.name = name
            notification.postID = postID
            notification.userID = uid
            // process timestamp
            notification.timestamp = timestamp
            if let profileImageURL = userNotifications["profileImageURL"] as? String {
                notification.profileImageURL = profileImageURL
            }
            
            self.relates.insert(notification, at: 0)
            
            // Wait until all notifications are downloaded, then reload.
            if self.initialLoad == false {
                self.tableView.reloadData()
            }

            
            
        })
        
        // Checks when all notifications are loaded
        notificationsRef.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.tableView.reloadData()
        })
        
    }
    
}
