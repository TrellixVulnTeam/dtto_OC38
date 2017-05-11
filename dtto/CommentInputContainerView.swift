//
//  CommentInputContainerView.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

fileprivate let PLACEHOLDERTEXT = "Add a comment..."

class CommentInputContainerView: UIView, UITextViewDelegate {

    weak var commentDelegate: CommentProtocol?
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self
        textView.text = PLACEHOLDERTEXT
        textView.textColor = .lightGray
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
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
        
        addSubview(textView)
        addSubview(topBorder)
        addSubview(postButton)
        
        topBorder.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        textView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        postButton.anchor(top: nil, leading: textView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 50, heightConstant: 30)
        
    }

    func postComment() {
        textView.resignFirstResponder()
        if textView.text != PLACEHOLDERTEXT {
//            commentDelegate?.postComment(textView: textView)
        }
    }
    
    func resetTextView() {
        textView.resignFirstResponder()
        textView.text = PLACEHOLDERTEXT
        textView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PLACEHOLDERTEXT {
            textView.text = ""
            textView.textColor = .black
        }
    }

}
