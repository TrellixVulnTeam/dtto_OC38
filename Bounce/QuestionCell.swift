//
//  QuestionCell.swift
//  Bounce
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
