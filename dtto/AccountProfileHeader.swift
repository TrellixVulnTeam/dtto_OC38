//
//  AccountProfileCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AccountProfileHeader: UIView {
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jitae Kim"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@jitae"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var relatesReceivedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "21 people found Jae helpful."
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "profile")
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(relatesReceivedCountLabel)
        addSubview(profileImage)
        
        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: profileImage.leadingAnchor, bottom: nil, topConstant: 20, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        usernameLabel.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, trailing: profileImage.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        relatesReceivedCountLabel.anchor(top: usernameLabel.bottomAnchor, leading: leadingAnchor, trailing: profileImage.leadingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 20, widthConstant: 0, heightConstant: 0)
        profileImage.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 20, leadingConstant: 0, trailingConstant: 10, bottomConstant: 20, widthConstant: 80, heightConstant: 80)
        
    }
    
}
