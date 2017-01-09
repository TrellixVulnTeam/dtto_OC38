//
//  ChatListCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class ChatListCell: BaseCollectionViewCell {

    let profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.image = #imageLiteral(resourceName: "profile")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jitae"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Some last message text"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.text = "Nov 11"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(timestampLabel)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        nameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: timestampLabel.leadingAnchor, bottom: profileImage.centerYAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        lastMessageLabel.anchor(top: profileImage.centerYAnchor, leading: profileImage.trailingAnchor, trailing: timestampLabel.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        timestampLabel.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        timestampLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .horizontal)
        
    }
    
}
