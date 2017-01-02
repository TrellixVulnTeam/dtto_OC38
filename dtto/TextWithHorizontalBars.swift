//
//  TextWithHorizontalBars.swift
//  dtto
//
//  Created by Jitae Kim on 1/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class TextWithHorizontalBars: UIView {

    var textLabel = UILabel()
    
    init(string: String) {
        super.init(frame: .zero)
        self.textLabel.text = string
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(textLabel)
        textLabel.textColor = .lightGray
//        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.font = UIFont.boldSystemFont(ofSize: 13)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let leftLine = UIView()
        leftLine.backgroundColor = .lightGray
        addSubview(leftLine)
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale).isActive = true
        leftLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftLine.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: -30).isActive = true
        leftLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let rightLine = UIView()
        rightLine.backgroundColor = .lightGray
        addSubview(rightLine)
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale).isActive = true
        rightLine.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 30).isActive = true
        rightLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
