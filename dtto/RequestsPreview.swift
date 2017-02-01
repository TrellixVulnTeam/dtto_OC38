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
    let requestsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
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
        
        profile.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        profile.anchorCenterYToSuperview()
        
        badge.anchor(top: profile.topAnchor, leading: nil, trailing: profile.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        requestsLabel.anchor(top: nil, leading: profile.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        requestsLabel.anchorCenterYToSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
