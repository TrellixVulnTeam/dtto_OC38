//
//  PostProfileCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/4/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostProfileCell: BaseCollectionViewCell {

    weak var postDelegate: PostProtocol?
    
    let profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = .black
//        return label
//    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        return button
    }()
    
    func showMore(_ sender: UIButton) {
        postDelegate?.showMore(cell: self, sender: sender)
    }
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(profileImage)
//        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(moreButton)

        profileImage.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 15, trailingConstant: 10, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        profileImage.anchorCenterYToSuperview()
        
//        nameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: moreButton.leadingAnchor, bottom: profileImage.centerYAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        usernameLabel.anchor(top: nil, leading: profileImage.trailingAnchor, trailing: moreButton.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        usernameLabel.anchorCenterYToSuperview()
        
        moreButton.anchor(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        moreButton.anchorCenterYToSuperview()
        moreButton.setImage(#imageLiteral(resourceName: "more-black"), for: .normal)
        
    }

}

