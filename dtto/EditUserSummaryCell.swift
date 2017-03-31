//
//  EditUserSummaryCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserSummaryCell: BaseTableViewCell {

    let summaryTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(summaryTextView)
        
        summaryTextView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 100)
        
    }

}
