//
//  TextWithHorizontalBars.swift
//  dtto
//
//  Created by Jitae Kim on 1/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class TextWithHorizontalBars: UIView {

    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let leftLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    let rightLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    init(string: String) {
        super.init(frame: .zero)
        self.textLabel.text = string
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(textLabel)
        addSubview(leftLine)
        addSubview(rightLine)
        
        textLabel.anchorCenterSuperview()

        leftLine.anchor(top: nil, leading: leadingAnchor, trailing: textLabel.leadingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 30, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        leftLine.anchorCenterYToSuperview()
        
        rightLine.anchor(top: nil, leading: textLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 30, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        rightLine.anchorCenterYToSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
