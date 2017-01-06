//
//  ProfileExpertiseCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileExpertiseCell: BaseTableViewCell {

    var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "relateSelected")
        return imageView
    
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I can help you with..."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "First tag."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(tagsLabel)
        
        icon.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        titleLabel.anchor(top: nil, leading: icon.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        tagsLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
    }
    
}
