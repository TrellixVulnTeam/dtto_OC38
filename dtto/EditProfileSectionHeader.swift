//
//  EditProfileSectionHeader.swift
//  dtto
//
//  Created by Jitae Kim on 3/30/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditProfileSectionHeader: UIView {

    let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    init(_ text: String) {
        super.init(frame: .zero)
        sectionHeaderLabel.text = text
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(sectionHeaderLabel)
        
        sectionHeaderLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        sectionHeaderLabel.anchorCenterYToSuperview()
    }
}
