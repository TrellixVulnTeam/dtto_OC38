//
//  ProfileSectionHeader.swift
//  dtto
//
//  Created by Jitae Kim on 1/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ProfileSectionHeader: UIView {

    var sectionLabel = UILabel()
    var underline = HorizontalBar()
    
    init(sectionTitle: String) {
        super.init(frame: .zero)
        self.sectionLabel.text = sectionTitle
        setupViews()
        
    }
    
    func setupViews() {
        
        backgroundColor = .white
        sectionLabel.textColor = Color.darkNavy
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 11)

        addSubview(sectionLabel)
        addSubview(underline)
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underline.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underline.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
