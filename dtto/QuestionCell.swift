//
//  QuestionCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

enum ChatState {
    
    case normal
    case requested
    case ongoing
}

class QuestionCell: UICollectionViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var hashTags: UILabel!

    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var requestChatDelegate: QuestionProtocol?
    
    var chatState: ChatState = .normal {
        didSet {
            switch chatState {
            case .normal:
                chatButton.setTitle("Request Chat", for: .normal)
                print("NORMAL")
            case .requested:
                chatButton.setTitle("Chat requested", for: .normal)
                print("REQUESTED")
            case .ongoing:
                chatButton.setTitle("Chat ongoing", for: .normal)
                print("ONGOING")
            }
        }
    }
    
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

    @IBAction func requestChat(_ sender: UIButton) {
        requestChatDelegate?.requestChat(row: sender.tag, chatState: chatState)
    }
    @IBAction func showMore(_ sender: UIButton!) {
        
        requestChatDelegate?.showMore(row: sender.tag, sender: sender)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
