//
//  PostTextCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostTextCell: BaseTableViewCell {
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let leftQuotationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "quote-left")
        return imageView
    }()
    
    let rightQuotationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "quote-right")
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubview(postLabel)
        addSubview(leftQuotationImage)
        addSubview(rightQuotationImage)
        
        leftQuotationImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 35, heightConstant: 35)
        
        postLabel.anchor(top: leftQuotationImage.centerYAnchor, leading: leftQuotationImage.trailingAnchor, trailing: nil, bottom: rightQuotationImage.centerYAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        rightQuotationImage.anchor(top: nil, leading: postLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 35, heightConstant: 35)
        
    }

}
