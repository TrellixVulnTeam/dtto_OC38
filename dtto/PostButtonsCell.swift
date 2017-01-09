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
class PostButtonsCell: BaseCollectionViewCell {

    weak var requestChatDelegate: PostProtocol?
    var chatState: ChatState = .normal {
        didSet {
            switch chatState {
            case .normal:
                chatButton.setTitle("Request Chat", for: .normal)
                chatButton.setImage(#imageLiteral(resourceName: "chatNormal"), for: .normal)
                print("NORMAL")
            case .requested:
                chatButton.setTitle("Chat requested!", for: .normal)
                chatButton.setImage(#imageLiteral(resourceName: "chatSelected"), for: .normal)
                print("REQUESTED")
            case .ongoing:
                chatButton.setTitle("Chat ongoing", for: .normal)
                print("ONGOING")
            }
        }
    }
    
    let relateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "relate"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "relateSelected"), for: .selected)
        return button
    }()
    
    lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "chatNormal"), for: .normal)
        button.setTitle("Request Chat", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: -10)
        button.addTarget(self, action: #selector(requestChat(_:)), for: .touchUpInside)
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        return button
    }()
    
    func relate(_ sender: UIButton) {
        sender.bounceAnimate()
        relateButton.isSelected = !relateButton.isSelected
    }
    
    func requestChat(_ sender: UIButton) {
        sender.bounceAnimate()
        requestChatDelegate?.requestChat(section: sender.tag, chatState: chatState)
        
    }
    
    override func setupViews() {
        super.setupViews()
        relateButton.addTarget(self, action: #selector(relate(_:)), for: .touchUpInside)
        
        addSubview(relateButton)
        addSubview(chatButton)
        addSubview(shareButton)
        
        relateButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 5, leadingConstant: 10, trailingConstant: 0, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
        chatButton.anchor(top: topAnchor, leading: relateButton.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        shareButton.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 5, leadingConstant: 0, trailingConstant: 10, bottomConstant: 5, widthConstant: 0, heightConstant: 0)
        
    }

}
