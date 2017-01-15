//
//  PostAddTagsCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostAddTagsCell: BaseTableViewCell {

    let tagsTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = Color.textGray
        textView.text = "Add tags..."
        textView.font = UIFont.systemFont(ofSize: 13)
        return textView
    }()
    
    override func setupViews() {
        
        addSubview(tagsTextView)
        
        tagsTextView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }


}
