//
//  PostToolbar.swift
//  dtto
//
//  Created by Jitae Kim on 1/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import RAMPaperSwitch

class PostToolbar: UIView {

    weak var composePostViewController: ComposePostViewController? {
        didSet {
            anonymousToggle.addTarget(composePostViewController, action: #selector(ComposePostViewController.toggle(_:)), for: .valueChanged)
        }
    }
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let anonymousLabel: UILabel = {
        let label = UILabel()
        label.text = "Posting Publicly"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var anonymousToggle: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.onTintColor = Color.darkNavy
        toggle.thumbTintColor = .white
        toggle.isOn = true
        return toggle
    }()
    
    let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(topBorder)
        addSubview(anonymousLabel)
        addSubview(anonymousToggle)
        addSubview(characterCountLabel)
        
        topBorder.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        
        anonymousLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        anonymousToggle.anchor(top: topAnchor, leading: anonymousLabel.trailingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 0)
        
        characterCountLabel.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
