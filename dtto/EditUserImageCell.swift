
//
//  EditUserImageCell.swift
//  dtto
//
//  Created by Jitae Kim on 1/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditUserImageCell: BaseTableViewCell {

    weak var profileViewControllerDelegate: ProfileEditViewController?
    
    lazy var profileImage: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        return button
    }()
    
    let imageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "plus")
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImage)
        profileImage.addSubview(imageIcon)
        
        profileImage.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 50, heightConstant: 50)
        
        imageIcon.anchorCenterSuperview()
        
    }
    
    func choosePhoto() {
        profileViewControllerDelegate?.showImagePicker()
        profileImage.isSelected = false
    }

}
