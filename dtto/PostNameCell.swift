//
//  PostPrivacyCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostNameCell: BaseTableViewCell {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "@jk"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let postKeywordImage = UIImageView(image: #imageLiteral(resourceName: "keyword"))
    
    let keywordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Insert a keyword"
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(postKeywordImage)
        addSubview(keywordTextField)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        profileImageView.anchorCenterYToSuperview()
        profileImageView.setContentHuggingPriority(.greatestFiniteMagnitude, for: .horizontal)

        nameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
//        let stackView = UIStackView(arrangedSubviews: [nameLabel, postKeyword])
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 5
        
        postKeywordImage.anchor(top: nil, leading: nameLabel.leadingAnchor, trailing: nil, bottom: profileImageView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 20, heightConstant: 20)
        
        keywordTextField.anchor(top: nil, leading: postKeywordImage.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        keywordTextField.centerYAnchor.constraint(equalTo: postKeywordImage.centerYAnchor).isActive = true
        

//        addSubview(stackView)
//        
//        stackView.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: profileImageView.bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        stackView.anchorCenterYToSuperview()
        
    }

}
