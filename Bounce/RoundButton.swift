//
//  RoundButton.swift
//  Bounce
//
//  Created by Jitae Kim on 11/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        
    }

}
