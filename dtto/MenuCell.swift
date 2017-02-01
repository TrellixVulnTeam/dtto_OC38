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
        
        self.addSubview(image)
        image.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 25, heightConstant: 25)
        image.anchorCenterSuperview()
    }
    
}

class TextCell: BaseCollectionViewCell {
    
    let label = UILabel()
    
    override func setupViews() {

        label.textColor = .black
        addSubview(label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
