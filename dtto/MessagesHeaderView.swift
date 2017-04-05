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
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "You are now connected with jae regarding your post about dtto"
        label.numberOfLines = 2
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
        
        introLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
