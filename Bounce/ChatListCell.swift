//
//  ChatListCell.swift
//  Bounce
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class ChatListCell: BaseCollectionViewCell {
    
    let profile = UIImageView()
    let lastMessage = UILabel()
    let timeStamp = UILabel()
    
    override func setupViews() {
        super.setupViews()
        addSubview(profile)
        profile.image = #imageLiteral(resourceName: "chat")
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
    

    }
    
    
}
