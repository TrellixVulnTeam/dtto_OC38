//
//  DestructiveCell.swift
//  dtto
//
//  Created by Jitae Kim on 4/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class DestructiveCell: BaseTableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchorCenterSuperview()
        
    }
    
}
