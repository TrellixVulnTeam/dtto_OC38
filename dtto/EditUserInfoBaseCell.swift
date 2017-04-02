//
//  EditUserInfoBaseCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/17/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserInfoBaseCell: BaseTableViewCell {

    let userInfoTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.sizeToFit()
        textView.isScrollEnabled = false
        return textView
    }()
    
    let underline = HorizontalBar()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(userInfoTextView)
        addSubview(underline)
        
        userInfoTextView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        underline.anchor(top: userInfoTextView.bottomAnchor, leading: userInfoTextView.leadingAnchor, trailing: userInfoTextView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1)
    }

}
