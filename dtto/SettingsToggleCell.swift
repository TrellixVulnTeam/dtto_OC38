//
//  SettingsToggleCell.swift
//  dtto
//
//  Created by Jitae Kim on 4/10/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SettingsToggleCell: BaseTableViewCell {

    weak var settingsDelegate: SettingsProtocol?
    
    let titleLabel = UILabel()
    
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleNotification), for: .valueChanged)
        return toggle
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(toggle)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
        toggle.anchor(top: nil, leading: titleLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        toggle.anchorCenterYToSuperview()
        
    }
    
    func toggleNotification() {
        
        if toggle.isOn {
            settingsDelegate?.toggleNotifications(cell: self)
        }
        else {
            settingsDelegate?.toggleNotifications(cell: self)
        }
    }
    
}
