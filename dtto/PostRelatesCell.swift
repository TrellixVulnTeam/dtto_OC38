//
//  PostStatsCell.swift
//  dtto
//
//  Created by Jitae Kim on 5/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostRelatesCell: BaseTableViewCell {
    
    let relatesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    var relatesCount: Int = 0 {
        didSet {
            if relatesCount == 0 {
                relatesLabel.removeFromSuperview()
            }
            else if relatesCount == 1 {
                relatesLabel.text = String(relatesCount) + " person relates to this"
                addSubview(relatesLabel)
                
                relatesLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
            }
            else {
                relatesLabel.text = String(relatesCount) + " people relate to this"
                addSubview(relatesLabel)
                
                relatesLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
            }
        }
    }
    
//    override func setupViews() {
//        super.setupViews()
//        
//        addSubview(relatesLabel)
//        
//        relatesLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 15, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
//        
//    }
    
}
