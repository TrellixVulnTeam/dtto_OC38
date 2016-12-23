//
//  FloatingTextField.swift
//  dtto
//
//  Created by Jitae Kim on 11/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class FloatingTextField: SkyFloatingLabelTextFieldWithIcon {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clearButtonMode = .whileEditing
        tintColor = Color.lightGreen
        selectedIconColor = Color.lightGreen
        selectedLineColor = Color.lightGreen
        selectedTitleColor = Color.lightGreen
        iconFont = UIFont(name: "FontAwesome", size: 15)
        iconColor = Color.lightGray
        errorColor = Color.darkSalmon

    }

}
