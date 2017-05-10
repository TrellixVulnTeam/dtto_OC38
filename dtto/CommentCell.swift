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
    weak var navigationDelegate: CommentProtocol?
    
    lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(expandReplies), for: .touchUpInside)
        button.backgroundColor = .black
        return button
    }()
    
    let profileImageView: RoundImageView = {
        let imageView = RoundImageView()
        imageView.image = #imageLiteral(resourceName: "profile")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let editTimestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "Edited"
        label.textAlignment = .left
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewProfile))
        profileImageView.addGestureRecognizer(profileTapGesture)
        let usernameTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewProfile))
        usernameLabel.addGestureRecognizer(usernameTapGesture)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
        addSubview(editTimestampLabel)
        addSubview(commentLabel)
        
        if hasReplies {
            // add the expand button
            addSubview(expandButton)
            
            expandButton.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 0)
            
            profileImageView.anchor(top: topAnchor, leading: expandButton.trailingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 40, heightConstant: 40)
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true

        }
        else {
            
            profileImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 40, heightConstant: 40)
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
            
        }
        
        usernameLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        timestampLabel.anchor(top: profileImageView.topAnchor, leading: usernameLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        editTimestampLabel.anchor(top: profileImageView.topAnchor, leading: timestampLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        editTimestampLabel.setContentCompressionResistancePriority(.leastNormalMagnitude, for: .horizontal)
        
        commentLabel.anchor(top: usernameLabel.bottomAnchor, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        commentLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
        
        
    }
    
    func viewProfile() {
        navigationDelegate?.viewProfile(cell: self)
    }
    
    func expandReplies() {
        print("expand replies")
    }

}
