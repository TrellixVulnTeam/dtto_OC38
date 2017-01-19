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
        label.text = "Jae"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(name)
        addSubview(relatesReceivedCount)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 70, heightConstant: 70)
        
        name.anchor(top: profileImage.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
//        relatesReceivedCount.anchor(top: profileImage.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

    }

    
}
