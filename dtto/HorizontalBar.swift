//
//  HorizontalBar.swift
//  dtto
//
//  Created by Jitae Kim on 1/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class HorizontalBar: UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    func setupViews() {
        
        let bar = UIView()
        bar.backgroundColor = .lightGray
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale).isActive = true
        bar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
