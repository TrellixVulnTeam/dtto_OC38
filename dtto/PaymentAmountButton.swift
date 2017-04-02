//
//  PaymentAmountButton.swift
//  dtto
//
//  Created by Jitae Kim on 4/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PaymentAmountButton: RoundButton {

    var dollarAmount: Int

    init(dollarAmount: Int) {
        self.dollarAmount = dollarAmount
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        tintColor = Color.darkNavy
        setTitleColor(Color.darkNavy, for: .normal)
        
    }

}
