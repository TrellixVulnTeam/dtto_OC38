//
//  ImageCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ImageCell: BaseCollectionViewCell {
    
    let image = UIImageView()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(image)
        
        image.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        image.anchorCenterSuperview()
    }
    
}

class TextCell: BaseCollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        
        label.anchorCenterSuperview()

    }
}
