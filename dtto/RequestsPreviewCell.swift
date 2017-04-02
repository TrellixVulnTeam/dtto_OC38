//
//  Requests.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class RequestsPreviewCell: BaseTableViewCell {
    
    let profileImageView = RoundImageView()
    
    let requestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Tap to Review"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let badge = MIBadgeButton()
    weak var notificationsPageDelegate: NotificationsPage?
    
    var requestsCount: Int? {
        willSet {
            requestsLabel.fadeOut(withDuration: 0.2)
        }
        didSet {
            requestsLabel.fadeIn(withDuration: 0.2)
            // maybe in willset, fadeout, then in.
            guard let requestsCount = requestsCount else { return }

            requestsLabel.text = "Chat Requests"
            
            badge.badgeString = "\(requestsCount)"
        }
    }
    
    let underline = HorizontalBar()
    
    override func setupViews() {
        super.setupViews()
        getRequestsCount()
        backgroundColor = .white
        badge.badgeBackgroundColor = .red
        badge.badgeTextColor = .white
        
        profileImageView.image = #imageLiteral(resourceName: "profile")
        
        addSubview(requestsLabel)
        addSubview(subLabel)
        addSubview(profileImageView)
        addSubview(badge)
        addSubview(underline)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        profileImageView.anchorCenterYToSuperview()

        badge.anchor(top: profileImageView.topAnchor, leading: nil, trailing: profileImageView.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        let stackView = UIStackView(arrangedSubviews: [requestsLabel, subLabel])
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        stackView.anchorCenterYToSuperview()
        
        underline.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 20, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    func getRequestsCount() {
        guard let userID = defaults.getUID() else { return }
        let requestsCountRef = FIREBASE_REF.child("users/\(userID)/requestsCount")
        requestsCountRef.observe(.value, with: { snapshot in
            self.requestsCount = snapshot.value as? Int ?? 0

        })
        
    }

    
}
