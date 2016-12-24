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
    let requestsLabel = UILabel()
    let badge = MIBadgeButton()
    
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
        backgroundColor = .white
        badge.badgeBackgroundColor = .red
        badge.badgeTextColor = .white
        
        profile.image = #imageLiteral(resourceName: "user")
        
        addSubview(requestsLabel)
        addSubview(profile)
        addSubview(badge)
        
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.topAnchor.constraint(equalTo: profile.topAnchor, constant: 10).isActive = true
        badge.trailingAnchor.constraint(equalTo: profile.trailingAnchor, constant: -10).isActive = true
        
        requestsLabel.translatesAutoresizingMaskIntoConstraints = false
        requestsLabel.leadingAnchor.constraint(equalTo: profile.trailingAnchor, constant: 10).isActive = true
        requestsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        requestsLabel.textColor = .black
        
    }

    
}
