//
//  MessagesHeaderView.swift
//  dtto
//
//  Created by Jitae Kim on 4/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class MessagesHeaderView: UICollectionReusableView {
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "You are now connected with jae regarding your post about dtto"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = Color.darkNavy
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(introLabel)
        
        introLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 5, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
    }
}
