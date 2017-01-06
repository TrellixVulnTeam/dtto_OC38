//
//  PostPrivacyCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostPrivacyCell: BaseTableViewCell {

    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jitae Kim"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    let privacyToggle: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.isOn = false
        return toggle
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(privacyToggle)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        nameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        privacyToggle.anchor(top: nil, leading: nameLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        privacyToggle.setContentHuggingPriority(.greatestFiniteMagnitude, for: .horizontal)
        privacyToggle.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
    }

}
