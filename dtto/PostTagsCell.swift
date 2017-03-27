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
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()

    var relatesCount: Int = 0 {
        didSet {
            if relatesCount == 1 {
                relatesLabel.text = String(relatesCount) + " person relates to this"
            }
            else {
                relatesLabel.text = String(relatesCount) + " people relate to this"
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
//        addSubview(relatesIcon)
        addSubview(relatesLabel)
        
//        relatesIcon.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
//        relatesIcon.anchorCenterYToSuperview()
        relatesLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
