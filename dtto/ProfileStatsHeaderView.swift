//
//  ProfileStatsHeaderView.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileStatsHeaderView: UIView {
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.darkNavy
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }()
    
    let underline = HorizontalBar()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(sectionLabel)
        addSubview(underline)
        
        sectionLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        sectionLabel.anchorCenterYToSuperview()

        underline.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
