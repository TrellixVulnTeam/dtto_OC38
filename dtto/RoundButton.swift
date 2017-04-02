//
//  RoundButton.swift
//  dtto
//
//  Created by Jitae Kim on 11/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
    }

}
