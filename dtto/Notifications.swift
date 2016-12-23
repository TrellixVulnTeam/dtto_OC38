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
    var relates = [Notification]()
    
    override func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
        cell.desc.text = "\(relates[indexPath.item].name) related to you."
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
        profile.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        profile.trailingAnchor.constraint(equalTo: desc.leadingAnchor, constant: -10).isActive = true
        desc.centerYAnchor.constraint(equalTo: profile.centerYAnchor).isActive = true
        desc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
    }
    
    
}

