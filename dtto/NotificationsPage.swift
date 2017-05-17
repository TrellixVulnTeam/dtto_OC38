//
//  Notifications.swift
//  dtto
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsPage: BaseCollectionViewCell {
    
    var notifications = [UserNotification]() {
        didSet {
            if notifications.count > 0 {
                tipLabel.alpha = 0
                tableView.fadeIn()
            }
            else {
                tableView.fadeOut()
                tipLabel.fadeIn()
            }
        }
    }
    var initialLoad = true
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textGray
        label.textAlignment = .center
        label.text = "Start posting to receive notifications."
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .singleLine
        
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: "NotificationsCell")
        
        addSubview(tipLabel)
        
        tipLabel.anchorCenterSuperview()

    }
    
}
extension NotificationsPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notification = notifications[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! NotificationsCell
        
        let boldFont = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        let boldString = NSMutableAttributedString(string: notification.getSenderName(), attributes:boldFont)
        
        let normalFont = [NSFontAttributeName : UIFont.systemFont(ofSize: 14)]
        
        let notificationText: NSMutableAttributedString
        
        switch notification.getNotificationType() {
            
        case .relate:
            notificationText = NSMutableAttributedString(string: " relates to your post. ", attributes: normalFont)
        case .comment:
            notificationText = NSMutableAttributedString(string: " commented on your post. ", attributes: normalFont)
        case .resolve:
            notificationText = NSMutableAttributedString(string: " endorsed you. ", attributes: normalFont)
            
        }
        
        let timestampText = NSMutableAttributedString(string: (notification.getTimestamp()?.timeAgoSinceDate(numericDates: true))!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : UIColor.lightGray])

        boldString.append(notificationText)
        boldString.append(timestampText)
        
        cell.notificationLabel.attributedText = boldString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Look up the notification type, and push the correct view
        let notification = notifications[indexPath.row]
        switch notification.getNotificationType() {
        case .relate, .comment:
            // TODO: Push the specific post screen.
            guard let postID = notification.getPostID() else { return }
            let vc = PostViewController(postID)
            masterViewDelegate?.navigationController?.pushViewController(vc, animated: true)
            break
        case .resolve:
            // Create a chat object from the notification.
            guard let userID = defaults.getUID(), let chatID = notification.getChatID(), let postID = notification.getPostID() else { return }
            
            let chat = Chat(chatID: chatID, postID: postID, helperID: userID, posterID: notification.getSenderID())
            
            let messagesViewController = MessagesViewController(chat: chat)
            
            masterViewDelegate?.navigationController?.pushViewController(messagesViewController, animated: true)
            
        }
    }
    
}
