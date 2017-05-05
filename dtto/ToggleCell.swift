//
//  ToggleCell.swift
//  dtto
//
//  Created by Jitae Kim on 4/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ToggleCell: BaseTableViewCell {
    
    weak var chatSettingsDelegate: ChatSettings?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow Notifications"
        return label
    }()
    
    lazy var notificationsToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = Color.lightGreen
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(toggleNotifications), for: .valueChanged)
        return toggle
    }()
    
    func toggleNotifications() {
        chatSettingsDelegate?.toggleNotifications(notificationsToggle.isOn)
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(notificationsToggle)
        
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        notificationsToggle.anchor(top: nil, leading: titleLabel.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        notificationsToggle.anchorCenterYToSuperview()
        
    }
    
}

