//
//  ChatListCell.swift
//  Bounce
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class ChatListCell: UICollectionViewCell {

    @IBOutlet weak var profile: RoundImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.lightGray
        self.selectedBackgroundView = backgroundView
    }
    
}
