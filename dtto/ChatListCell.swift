//
//  ChatListCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ChatListCell: BaseTableViewCell {

    var chat: Chat? {
        didSet {
            setupNameAndProfileImage()
            
//            lastMessageLabel.text = chat?.lastMessage
            

        }
    }
    
    let profileImage: RoundImageView = {
        let imageView = RoundImageView()
        imageView.image = #imageLiteral(resourceName: "profile")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jitae"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(timestampLabel)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        nameLabel.anchor(top: profileImage.topAnchor, leading: profileImage.trailingAnchor, trailing: timestampLabel.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        lastMessageLabel.anchor(top: nameLabel.bottomAnchor, leading: profileImage.trailingAnchor, trailing: timestampLabel.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        timestampLabel.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        timestampLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .horizontal)
        
    }

    
    private func setupNameAndProfileImage() {
        let chatPartnerId: String?
        
        if chat?.posterID == FIRAuth.auth()?.currentUser?.uid {
            chatPartnerId = chat?.helperID
        } else {
            chatPartnerId = chat?.posterID
        }
        
        if let id = chatPartnerId {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.lastMessageLabel.text = dictionary["name"] as? String
                    
//                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
//                        self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
//                    }
                }
            })
        }
    }

}
