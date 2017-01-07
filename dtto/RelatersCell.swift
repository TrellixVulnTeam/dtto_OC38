//
//  RelatersCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class RelatersCell: BaseTableViewCell {

    let profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        profileImage.anchorCenterYToSuperview()
        
        nameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: trailingAnchor, bottom: profileImage.centerYAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        usernameLabel.anchor(top: profileImage.centerYAnchor, leading: profileImage.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    
    
}
