//
//  FloatingTextField.swift
//  dtto
//
//  Created by Jitae Kim on 11/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class FloatingTextField: SkyFloatingLabelTextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clearButtonMode = .whileEditing
        tintColor = Color.darkNavy
        lineColor = Color.lightGray
        selectedLineColor = Color.darkNavy
        selectedTitleColor = Color.darkNavy
//        selectedIconColor = Color.darkNavy
//        iconFont = UIFont(name: "FontAwesome", size: 15)
//        iconColor = Color.lightGray
        errorColor = Color.darkSalmon

    }

}
