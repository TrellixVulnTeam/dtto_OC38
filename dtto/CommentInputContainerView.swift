//
//  CommentInputContainerView.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class CommentInputContainerView: UIView, UITextViewDelegate {

    weak var commentDelegate: PostViewController?
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self
        return textView
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.darkNavy
        button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        return button
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
        
        addSubview(topBorder)
        addSubview(textView)
        addSubview(postButton)
        
        topBorder.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        textView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 50)
        postButton.anchor(top: nil, leading: textView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 50, heightConstant: 30)
        
    }

    func postComment() {
        textView.resignFirstResponder()
        commentDelegate?.postComment(textView: textView)
    }

}
