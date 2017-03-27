//
//  PostToolbar.swift
//  dtto
//
//  Created by Jitae Kim on 1/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

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
    
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Post Anonymously?"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    let anonymousToggle: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.onTintColor = Color.darkNavy
//        toggle.thumbTintColor = .white
//        toggle.tintColor = .lightGray
        return toggle
    }()
    
    let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    init(isPublic: Bool) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 50))
        enablePublic(enable: isPublic)
        
        backgroundColor = .white
        
        addSubview(topBorder)
        addSubview(privacyLabel)
        addSubview(anonymousToggle)
        addSubview(characterCountLabel)
        
        topBorder.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        
        characterCountLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        privacyLabel.anchor(top: topAnchor, leading: nil, trailing: anonymousToggle.leadingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        anonymousToggle.anchor(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 10, bottomConstant: 10, widthConstant: 50, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enablePublic(enable: Bool) {

        if enable {
            anonymousToggle.isOn = true
            privacyLabel.text = "Posting Anonymously"
            privacyLabel.textColor = .white
            backgroundColor = Color.darkNavy
        }
        else {
            anonymousToggle.isOn = false
            privacyLabel.text = "Post Anonymously?"
            privacyLabel.textColor = Color.darkNavy
            backgroundColor = .white
        }
    }
    
}
