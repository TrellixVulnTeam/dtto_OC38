//
//  EditUserInfoBaseCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/17/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserInfoBaseCell: BaseTableViewCell {

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "Name"
        return label
    }()
    
    let userInfoTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add your name"
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.sizeToFit()
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(infoLabel)
        addSubview(userInfoTextView)
        
        infoLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 80, heightConstant: 0)
        infoLabel.anchorCenterYToSuperview()
        
        userInfoTextView.anchor(top: topAnchor, leading: infoLabel.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        userInfoTextView.anchorCenterYToSuperview()
        
    }

}
