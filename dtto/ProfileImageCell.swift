//
//  ProfileImageCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileImageCell: BaseTableViewCell {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "profile")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jae"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@jae"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let postsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Post"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let postsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "15"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let relatableCountHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Relatable"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let relatableCountLabel: UILabel = {
        let label = UILabel()
        label.text = "11"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let helpsGivenCountHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Helpful"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let helpsGivenCountLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Some summary extending several lines here"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(summaryLabel)

        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 90, heightConstant: 90)
        
        summaryLabel.anchor(top: profileImageView.bottomAnchor, leading: profileImageView.leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)

        nameLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        usernameLabel.anchor(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        nameStackView.axis = .vertical
        
        addSubview(nameStackView)
        
        nameStackView.anchor(top: nil, leading: profileImageView.trailingAnchor, trailing: nil, bottom: profileImageView.bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        nameStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        let postsStackView = UIStackView(arrangedSubviews: [postsCountLabel, postsHeaderLabel])
        postsStackView.axis = .vertical
        postsStackView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewPosts))
        postsStackView.addGestureRecognizer(gesture)
        addSubview(postsStackView)
        
        let relatesStackView = UIStackView(arrangedSubviews: [relatableCountLabel, relatableCountHeaderLabel])
        relatesStackView.axis = .vertical
        addSubview(relatesStackView)
        
        let helpsStackView = UIStackView(arrangedSubviews: [helpsGivenCountLabel, helpsGivenCountHeaderLabel])
        helpsStackView.axis = .vertical
        addSubview(relatesStackView)
        
        let statsStackView = UIStackView(arrangedSubviews: [postsStackView, relatesStackView, helpsStackView])
        statsStackView.axis = .horizontal
        statsStackView.distribution = .equalSpacing
        addSubview(statsStackView)
        
        statsStackView.anchor(top: profileImageView.topAnchor, leading: nameStackView.leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    
    }

    func viewPosts() {
        
    }
}
