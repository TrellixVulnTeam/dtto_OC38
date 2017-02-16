//
//  PaymentCell.swift
//  dtto
//
//  Created by Jitae Kim on 2/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PaymentCell: BaseTableViewCell {

    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Color.darkNavy
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.darkNavy
        self.selectedBackgroundView = backgroundView
        
        addSubview(amountLabel)
        
        amountLabel.anchorCenterSuperview()
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if isHighlighted {
            amountLabel.textColor = .white
        }
        else {
            amountLabel.textColor = Color.darkNavy
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isSelected {
            amountLabel.textColor = .white
        }
        else {
            amountLabel.textColor = Color.darkNavy
        }
    }
    
}
