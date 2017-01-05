//
//  PostButtonsCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostButtonsCell: BaseCollectionViewCell {

    weak var requestChatDelegate: PostProtocol?
    
    lazy var relateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "relate"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "relateSelected"), for: .selected)
        
        button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(relate), for: .touchUpInside)
        
        return button
    }()
    
    let chatButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "chatNormal"), for: .normal)
        button.setTitle("Request Chat", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: -10)
        
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        
        return button
    }()
    
    func selectButton(_ sender: UIButton) {
        
        relateButton.isSelected = !relateButton.isSelected
        sender.bounceAnimate()
        
    }

    
    func relate() {
        
        

    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(relateButton)
        addSubview(chatButton)
        addSubview(shareButton)
        
        relateButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        chatButton.anchor(top: topAnchor, leading: relateButton.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        shareButton.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }

}
