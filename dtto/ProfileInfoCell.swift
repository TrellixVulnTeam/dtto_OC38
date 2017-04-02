//
//  ProfileInfoCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileInfoCell: BaseTableViewCell {

//    let icon: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "suitcase")
//        return imageView
//    }()
//    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override func setupViews() {
        super.setupViews()
        
//        addSubview(icon)
        addSubview(titleLabel)
        
//        icon.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
}
