//
//  PostButtonsCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

enum ChatState {
    case normal
    case requested
    case ongoing
}

class PostButtonsCell: BaseTableViewCell {

    weak var requestChatDelegate: PostProtocol?
    
    var chatState: ChatState = .normal {
        didSet {
            switch chatState {
            case .normal:
                chatButton.setTitle("Request Chat", for: .normal)
                chatButton.setImage(#imageLiteral(resourceName: "chatNormal"), for: .normal)
                print("NORMAL")
            case .requested:
                chatButton.setTitle("Chat Requested!", for: .normal)
                chatButton.setImage(#imageLiteral(resourceName: "chatSelected"), for: .normal)
                print("REQUESTED")
            case .ongoing:
                chatButton.setTitle("Chat Ongoing", for: .normal)
                chatButton.setImage(#imageLiteral(resourceName: "chatSelected"), for: .normal)
                print("ONGOING")
            }
        }
    }
    
    var related: Bool = false
    
    lazy var relateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -10)
        button.setImage(#imageLiteral(resourceName: "relate"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "relateSelected"), for: .selected)
        button.addTarget(self, action: #selector(relate(_:)), for: .touchUpInside)
        return button
    }()
    
    let relatesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var relatesCount: Int = 0 {
        didSet {
            if relatesCount == 1 {
                relatesCountLabel.text = String(relatesCount) + " person relates to this"
            }
            else {
                relatesCountLabel.text = String(relatesCount) + " people relate to this"
            }
        }
    }
    
    lazy var commentsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -10)
        button.setImage(#imageLiteral(resourceName: "comments"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(requestChat(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: -10)
        button.addTarget(self, action: #selector(requestChat(_:)), for: .touchUpInside)
        return button
    }()
    
    let chatCountsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        button.addTarget(self, action: #selector(sharePost(_:)), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()

        addSubview(relateButton)
        addSubview(relatesCountLabel)
        addSubview(commentsButton)
        addSubview(chatButton)
        addSubview(chatCountsLabel)
        addSubview(shareButton)
        
        let relatesStackView = UIStackView(arrangedSubviews: [relateButton])
        addSubview(relatesStackView)
        
        let commentsStackView = UIStackView(arrangedSubviews: [commentsButton])
        addSubview(commentsStackView)
        
        let chatStackView = UIStackView(arrangedSubviews: [chatButton, chatCountsLabel])
        addSubview(chatStackView)
        
        let shareStackView = UIStackView(arrangedSubviews: [shareButton])
        addSubview(shareStackView)
        
        let stackView = UIStackView(arrangedSubviews: [relatesStackView, commentsStackView, chatStackView, shareStackView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        
//        relateButton.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 15, trailingConstant: 0, bottomConstant: 0, widthConstant: 30, heightConstant: 30)
//        relateButton.anchorCenterYToSuperview()
//
//        relatesCountLabel.anchor(top: nil, leading: relateButton.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        
//        chatButton.anchor(top: nil, leading: relateButton.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 25)
//        chatButton.anchorCenterYToSuperview()
//        shareButton.anchor(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 15, bottomConstant: 0, widthConstant: 30, heightConstant: 30)
//        shareButton.anchorCenterYToSuperview()
        
    }
    
    func relate(_ sender: UIButton) {
        sender.bounceAnimate()
        requestChatDelegate?.relatePost(cell: self)
    }
    
    func requestChat(_ sender: UIButton) {
        sender.bounceAnimate()
        requestChatDelegate?.requestChat(cell: self, chatState: chatState)
        
    }
    
    func sharePost(_ sender: UIButton) {
        requestChatDelegate?.sharePost(cell: self)
    }

}
