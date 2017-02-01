//
//  Requests.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class Requests: BaseCollectionViewCell {
    
    let profile = UIImageView()
    let requestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
            
            if requestsCount == 1 {
                requestsLabel.text = "\(requestsCount) chat request"
            }
            else {
                requestsLabel.text = "\(requestsCount) chat requests"
            }
            
            badge.badgeString = "\(requestsCount)"
        }
    }
    
    override func setupViews() {
        super.setupViews()
//        getRequestsCount()
        backgroundColor = .white
        badge.badgeBackgroundColor = .red
        badge.badgeTextColor = .white
        
        profile.image = #imageLiteral(resourceName: "user")
        
        addSubview(requestsLabel)
        addSubview(profile)
        addSubview(badge)
        
        profile.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        profile.anchorCenterYToSuperview()

        badge.anchor(top: profile.topAnchor, leading: nil, trailing: profile.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

        requestsLabel.anchor(top: nil, leading: profile.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        requestsLabel.anchorCenterYToSuperview()

    }
    
    func getRequestsCount() {
        guard let userID = defaults.getUID() else { return }
        let requestsCountRef = FIREBASE_REF.child("users/\(userID)/requestsCount")
        requestsCountRef.observe(.value, with: { snapshot in 
            
            self.requestsCount = snapshot.value as? Int ?? 0
            
        })
        
    }

    
}
