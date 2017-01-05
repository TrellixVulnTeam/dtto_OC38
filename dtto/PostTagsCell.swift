//
//  PostTagsCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostTagsCell: BaseCollectionViewCell {

    let relatesIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "relateSelected")
        return imageView
    }()
    
    let relatesLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.text = "15 people related with this"
        return label
    }()

    
    override func setupViews() {
        super.setupViews()
        
        addSubview(relatesIcon)
        addSubview(relatesLabel)
        
        relatesIcon.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        relatesLabel.anchor(top: topAnchor, leading: relatesIcon.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
