//
//  NotificationsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseTableViewController {

    var relates = [UserNotification]()
    var initialLoad = true

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: "NotificationsCell")
        
    }
    
//    private func observeNotifications() {
//        
////        guard let userID = defaults.getUID() else { return }
//        let userID = "uid1"
//        let notificationsRef = FIREBASE_REF.child("relatesNotifications").child(userID)
//        notificationsRef.observe(.childAdded, with: { snapshot in
//            
//            guard let userNotifications = snapshot.value as? Dictionary<String, AnyObject> else { return }
//            
//            guard let uid = userNotifications["uid"] as? String, let name = userNotifications["name"] as? String, let postID = userNotifications["postID"] as? String, let timestamp = userNotifications["timestamp"] as? String else { return }
//            
//            let notification = UserNotification()
//            
//            notification.name = name
//            notification.postID = postID
//            notification.userID = uid
//            // process timestamp
//            notification.timestamp = timestamp
//            if let profileImageURL = userNotifications["profileImageURL"] as? String {
//                notification.profileImageURL = profileImageURL
//            }
//            
//            self.relates.insert(notification, at: 0)
//            
//            // Wait until all notifications are downloaded, then reload.
//            if self.initialLoad == false {
//                self.tableView.reloadData()
//            }
//            
//        })
//        
//        // Checks when all notifications are loaded
//        notificationsRef.observeSingleEvent(of: .value, with: { snapshot in
//            self.initialLoad = false
//            self.tableView.reloadData()
//        })
//        
//    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! NotificationsCell
        
        let boldFont = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: "Jae", attributes:boldFont)
        
        let normalFont = [NSFontAttributeName : UIFont.systemFont(ofSize: 15)]
        let suffixText = NSMutableAttributedString(string: " relates to your post", attributes: normalFont)
        
        boldString.append(suffixText)
        
        cell.notificationLabel.attributedText = boldString
        
        return cell
    }
    
}
