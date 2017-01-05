//
//  PostTextCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostTextCell: BaseCollectionViewCell {

    let postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(postLabel)
        
        postLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
    }

}
