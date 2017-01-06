//
//  ProfileImageCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileImageCell: BaseTableViewCell {

    var profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var relatesReceivedCount: UILabel = {
        let label = UILabel()
        label.text = "21 people found Jae helpful."
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    var name: UILabel = {
        let label = UILabel()
        label.text = "Jae, 24"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(relatesReceivedCount)
        addSubview(name)
        
        profileImage.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        profileImage.anchorCenterXToSuperview()
        
        relatesReceivedCount.anchor(top: profileImage.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        relatesReceivedCount.anchorCenterXToSuperview()
        
        name.anchor(top: relatesReceivedCount.bottomAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        name.anchorCenterXToSuperview()
        
        
        
    }

    
}
