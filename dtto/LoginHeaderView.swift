//
//  LoginHeaderView.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "dtto"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up to relate"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        backgroundColor = Color.darkNavy
    
        addSubview(titleLabel)
        addSubview(descLabel)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 50, leadingConstant: 30, trailingConstant: 30, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        titleLabel.anchorCenterXToSuperview()
        
        descLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 30, leadingConstant: 30, trailingConstant: 30, bottomConstant: 30, widthConstant: 0, heightConstant: 0)
        descLabel.anchorCenterXToSuperview()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
