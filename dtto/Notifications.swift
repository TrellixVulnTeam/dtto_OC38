//
//  Notifications.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class Notifications: BaseCollectionViewCell {
    
    var collectionView: UICollectionView!
    var relates = [UserNotification]()
    
    override func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.register(NotificationsCell.self, forCellWithReuseIdentifier: "NotificationsCell")

    }
    
    
}

extension Notifications: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return # of requests
        return relates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        print("reloaded")
        cell.desc.text = "\(relates[indexPath.item].name!) related to you."
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
}


class NotificationsCell: BaseCollectionViewCell {
    
    let profile = RoundImageView()
    let desc = UILabel()
    
    override func setupViews() {
        super.setupViews()
        profile.contentMode = .scaleAspectFill
        profile.image = #imageLiteral(resourceName: "profile")
//        desc.text = "This person related to you."
        desc.adjustsFontSizeToFitWidth = true
        desc.sizeToFit()
        addSubview(desc)
        addSubview(profile)
        
        profile.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        profile.anchorCenterYToSuperview()

        desc.anchor(top: nil, leading: profile.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        desc.anchorCenterYToSuperview()
    }
    
    
}

