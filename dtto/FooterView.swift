//
//  FooterView.swift
//  dtto
//
//  Created by Jitae Kim on 3/23/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(horizontalLine)
        
        horizontalLine.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 1)
        horizontalLine.anchorCenterXToSuperview()
    }
}
