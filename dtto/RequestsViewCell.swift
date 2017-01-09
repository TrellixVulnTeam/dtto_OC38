//
//  RequestsViewCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RequestsViewCell: BaseTableViewCell {

    weak var requestsDelegate: RequestsDelegate?

    let profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "check"), for: UIControlState())
        button.addTarget(self, action: #selector(acceptRequest(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "declineNormal"), for: UIControlState())
        button.addTarget(self, action: #selector(declineRequest(_:)), for: .touchUpInside)
        return button
    }()
    
    func acceptRequest(_ sender: UIButton!) {
        sender.bounceAnimate()
        requestsDelegate?.handleRequest(row: sender.tag, action: .accept)
    }
    
    func declineRequest(_ sender: UIButton!) {
        sender.bounceAnimate()
        requestsDelegate?.handleRequest(row: sender.tag, action: .decline)
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(displayNameLabel)
        addSubview(acceptButton)
        addSubview(declineButton)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        nameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: acceptButton.leadingAnchor, bottom: profileImage.centerYAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        displayNameLabel.anchor(top: profileImage.centerYAnchor, leading: profileImage.trailingAnchor, trailing: acceptButton.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        acceptButton.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        acceptButton.anchorCenterYToSuperview()
        
        declineButton.anchor(top: nil, leading: acceptButton.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        declineButton.anchorCenterYToSuperview()
        
    }
    
    
}
