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
    
    let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func setupViews() {
        
        addSubview(postTextView)
        
        postTextView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
//        let keyboardView = UIView()
//        keyboardView.backgroundColor = .white
//        keyboardView.addSubview(characterCountLabel)
//        characterCountLabel.anchor(top: keyboardView.topAnchor, leading: nil, trailing: keyboardView.trailingAnchor, bottom: keyboardView.bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
//        keyboardView.frame = .init(x: 0, y: 0, width: SCREENWIDTH, height: 50)
//        postTextView.inputAccessoryView = keyboardView
        
    }

}
