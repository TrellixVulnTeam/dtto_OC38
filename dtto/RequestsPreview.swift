//
//  RequestsPreview.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class RequestsPreview: UIView {

    let profile = RoundImageView()
    let name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        profile.contentMode = .scaleAspectFill
        profile.image = #imageLiteral(resourceName: "profile")
        addSubview(name)
        addSubview(profile)
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profile.bottomAnchor, constant: 10).isActive = true
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
