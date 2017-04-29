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
    var initialLoad = true
    
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
        
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: "NotificationsCell")

    }
    
}
extension NotificationsPage: UITableViewDelegate, UITableViewDataSource {
    
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
