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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = Color.gray247
        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
    
        return tableView
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .white: .white//change colors as per your requirements
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
