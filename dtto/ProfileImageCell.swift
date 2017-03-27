//
//  ProfileImageCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileImageCell: BaseTableViewCell {

    let profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let relatesReceivedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "21 people found Jae helpful."
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jae"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(relatesReceivedCountLabel)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 70, heightConstant: 70)
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
//        relatesReceivedCount.anchor(top: profileImage.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

    }

    
}
