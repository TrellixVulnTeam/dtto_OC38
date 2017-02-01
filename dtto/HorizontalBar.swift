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
        bar.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        bar.anchorCenterYToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
