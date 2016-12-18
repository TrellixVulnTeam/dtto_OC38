//
//  Notifications.swift
//  Bounce
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsPage:  BaseCollectionViewCell {
    
    var collectionView: UICollectionView!
    
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
        
        collectionView.register(Requests.self, forCellWithReuseIdentifier: "Requests")
        collectionView.register(Notifications.self, forCellWithReuseIdentifier: "Notifications")
    }
    

    
    
}

extension NotificationsPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Section: Int {
        
        case Requests
        case Notifications
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
            
        case .Requests:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Requests", for: indexPath) as! Requests
            return cell
        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Notifications", for: indexPath) as! Notifications
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let section = Section(rawValue: indexPath.section) else { return CGSize() }
        
        switch section {
            
        case .Requests:
            return CGSize(width: collectionView.frame.width, height: 70)
        case .Notifications:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 70)
            
        }
        
    }
    
}

