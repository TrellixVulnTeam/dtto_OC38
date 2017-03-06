//
//  EditUserInfoSearchCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/18/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserInfoSearchCell: BaseTableViewCell {

    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Name"
        return label
    }()
    
    let userInfoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add your school"
        textField.textColor = .lightGray
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    override func setupViews() {
        super.setupViews()
        
    }

}
