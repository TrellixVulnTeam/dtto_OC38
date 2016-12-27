//
//  QuestionCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var hashTags: UILabel!

    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var requestChatDelegate: QuestionProtocol?
    @IBAction func selectButton(_ sender: UIButton!) {
        if sender.isSelected {
            sender.isSelected = false
            sender.bounceAnimate()
        }
        else {
            sender.isSelected = true
            sender.bounceAnimate()
        }
    }

    @IBAction func showMore(_ sender: UIButton!) {
        
        requestChatDelegate?.showMore(row: sender.tag, sender: sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
