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
        return label
    }()

    var relatesCount: Int = 0 {
        didSet {
            if relatesCount == 1 {
                relatesLabel.text = String(relatesCount) + " relate"
            }
            else {
                relatesLabel.text = String(relatesCount) + " relates"
            }

        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(relatesIcon)
        addSubview(relatesLabel)
        
        relatesIcon.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        relatesIcon.anchorCenterYToSuperview()
        relatesLabel.anchor(top: topAnchor, leading: relatesIcon.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 0, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
        
    }

}
