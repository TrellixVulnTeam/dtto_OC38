//
//  BaseCollectionViewCell.swift
//  Bounce
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
