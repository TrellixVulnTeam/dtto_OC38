//
//  PostComposeCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostComposeCell: BaseTableViewCell {

    let postTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = Color.textGray
        textView.text = "What's on your mind?"
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    override func setupViews() {
        
        addSubview(postTextView)
        
        postTextView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
