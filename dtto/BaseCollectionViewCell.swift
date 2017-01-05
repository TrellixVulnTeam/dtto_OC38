//
//  BaseCollectionViewCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var masterViewDelegate: MasterCollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.gray247
        self.selectedBackgroundView = backgroundView
    }
}
