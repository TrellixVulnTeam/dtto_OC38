//
//  PostAnonymousCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostAnonymousCell: BaseTableViewCell {

    lazy var anonymousToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(toggle(_:)), for: .valueChanged)
        return toggle
    }()
    
    let anonymousLabel: UILabel = {
        let label = UILabel()
        label.text = "Posting Publicly"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        super.setupViews()

        contentView.backgroundColor = .black
//        anonymousToggle.duration = 0.2
        
        addSubview(anonymousLabel)
        addSubview(anonymousToggle)
        
        anonymousLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        anonymousLabel.anchorCenterYToSuperview()
        
        anonymousToggle.anchor(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        anonymousToggle.anchorCenterYToSuperview()
        
    }
    
    func toggle(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            if sender.isOn {
                self.anonymousLabel.text = "Posting Publicly"
                self.anonymousLabel.textColor = .black
            }
            else {
                self.anonymousLabel.text = "Posting Anonymously"
                self.anonymousLabel.textColor = .lightGray
            }
        })
        
    }

}
