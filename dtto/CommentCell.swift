//
//  CommentCell.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class CommentCell: BaseTableViewCell {

    var hasReplies = false
    var commentDelegate: CommentsTableView?
    
    lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(expandReplies), for: .touchUpInside)
        button.backgroundColor = .black
        return button
    }()
    
    let profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "profile")
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Jitae"
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
//        label.text = "Wow, that is great!"
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
        addSubview(commentLabel)
        
        if hasReplies {
            // add the expand button
            addSubview(expandButton)
            
            expandButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 0)
            
            profileImageView.anchor(top: topAnchor, leading: expandButton.trailingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 30, heightConstant: 30)

        }
        else {
            
            profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 30, heightConstant: 30)
            
        }
        
        usernameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        timestampLabel.anchor(top: profileImageView.topAnchor, leading: usernameLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        commentLabel.anchor(top: usernameLabel.bottomAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    func expandReplies() {
        print("expand replies")
    }

}
