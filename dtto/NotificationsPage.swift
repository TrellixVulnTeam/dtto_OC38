//
//  Notifications.swift
//  dtto
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class NotificationsPage:  BaseCollectionViewCell {
    
    var collectionView: UICollectionView!
    var relates = [Notification]()
    var requests = [Notification]()
    var initialLoad = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        observeNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        
        // Initialize Views
        
        let requestsPreview = UIView()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.addSubview(requestsPreview)
        self.addSubview(collectionView)
        
        // Setup Requests
        
        requestsPreview.backgroundColor = .black
        
        requestsPreview.translatesAutoresizingMaskIntoConstraints = false
        requestsPreview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        requestsPreview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        requestsPreview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        requestsPreview.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        requestsPreview.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Setup Relate Notifications
    
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.register(Requests.self, forCellWithReuseIdentifier: "Requests")
        collectionView.register(Notifications.self, forCellWithReuseIdentifier: "Notifications")
    }
    

    private func observeNotifications() {
        
        print("Getting notifications...")
        let notificationsRef = FIREBASE_REF.child("relatesNotifications/uid1")
        notificationsRef.observe(.childAdded, with: { snapshot in

            guard let userNotifications = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            guard let uid = userNotifications["uid"] as? String, let name = userNotifications["name"] as? String, let questionID = userNotifications["questionID"] as? String, let timestamp = userNotifications["timestamp"] as? String else { return }
            
            let notification = Notification()
            
            notification.name = name
            notification.questionID = questionID
            notification.userID = uid
            // process timestamp
            notification.timestamp = timestamp
            if let profileImageURL = userNotifications["profileImageURL"] as? String {
                notification.profileImageURL = profileImageURL
            }
            
            // Check if person wants to chat with user, or only related.
            if let _ = userNotifications["request"] {
                self.requests.insert(notification, at: 0)
            }
            self.relates.insert(notification, at: 0)
        
            
            // Wait until all notifications are downloaded, then reload.
            if self.initialLoad == false {
                self.collectionView.reloadData()
            }

            
            
        })
        
        // Checks when all notifications are loaded
        notificationsRef.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.collectionView.reloadData()
        })
        
    }

    
    
}

extension NotificationsPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    private enum Section: Int {
//        
//        case Requests
//        case Notifications
//        
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
//        switch section {
//            
//        case .Requests:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Requests", for: indexPath) as! Requests
////            cell.requests = requests
//            return cell
//        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Notifications", for: indexPath) as! Notifications
            cell.relates = relates
            return cell
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        guard let section = Section(rawValue: indexPath.section) else { return CGSize() }
//        
//        switch section {
//            
//        case .Requests:
//            return CGSize(width: collectionView.frame.width, height: 70)
//        case .Notifications:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 70)
            
//        }
        
    }
    
}

