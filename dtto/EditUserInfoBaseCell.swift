//
//  EditUserInfoBaseCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/17/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserInfoBaseCell: BaseTableViewCell {

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Name"
        return label
    }()
    
    let userInfoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add your name"
        textField.textColor = .lightGray
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(infoLabel)
        addSubview(userInfoTextField)
        
        infoLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        infoLabel.setContentHuggingPriority(.greatestFiniteMagnitude, for: .horizontal)
        
        userInfoTextField.anchor(top: nil, leading: infoLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        userInfoTextField.anchorCenterYToSuperview()
        
    }

}
