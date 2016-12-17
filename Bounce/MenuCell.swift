//
//  ImageCell.swift
//  Bounce
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ImageCell: BaseCollectionViewCell {
    
    var image = UIImageView()
    
    override func setupViews() {
        
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 25).isActive = true
        image.widthAnchor.constraint(equalToConstant: 25).isActive = true
        image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
}

class TextCell: BaseCollectionViewCell {
    
    let label = UILabel()
    
    override func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        addSubview(label)
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
