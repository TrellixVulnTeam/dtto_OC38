//
//  RequestsPreview.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class RequestsPreview: UIView {

    let profile = RoundImageView()
    let requestsLabel = UILabel()
    let badge = MIBadgeButton()
    
    var requestsCount: Int? {
        didSet {
            guard let requestsCount = requestsCount else { return }
            requestsLabel.text = "\(requestsCount) chat requests"
            badge.badgeString = "\(requestsCount)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        badge.badgeBackgroundColor = .red
        badge.badgeTextColor = .white
        
        profile.contentMode = .scaleAspectFill
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
        badge.topAnchor.constraint(equalTo: profile.topAnchor).isActive = true
        badge.trailingAnchor.constraint(equalTo: profile.trailingAnchor).isActive = true
        
        requestsLabel.translatesAutoresizingMaskIntoConstraints = false
        requestsLabel.leadingAnchor.constraint(equalTo: profile.trailingAnchor, constant: 10).isActive = true
        requestsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        requestsLabel.textColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
