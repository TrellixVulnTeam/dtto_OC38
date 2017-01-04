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
    var requestsCount: Int = 0
    
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.addSubview(collectionView)

        // Setup Relate Notifications
    
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.register(Requests.self, forCellWithReuseIdentifier: "Requests")
        collectionView.register(Notifications.self, forCellWithReuseIdentifier: "Notifications")
        
        observeChatRequestsCount()
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

    func observeChatRequestsCount() {
        
        guard let userID = defaults.getUID() else { return }
        let chatRequestsCountRef = FIREBASE_REF.child("users/\(userID)/requestsCount")
        chatRequestsCountRef.observe(.value, with: { snapshot in
            
            self.requestsCount = snapshot.value as? Int ?? 0
            self.collectionView.reloadData()
            
        })
        
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
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
            
        case .Requests:
            return 1
        case .Notifications:
            return relates.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
            
        case .Requests:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Requests", for: indexPath) as! Requests
            cell.requestsCount = requestsCount

            return cell
        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Notifications", for: indexPath) as! Notifications
            cell.relates = relates
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
            
        case .Requests:
            // go to requestsView
            let requestsView = RequestsViewController(requests: requests)
            masterViewDelegate?.navigationController?.pushViewController(requestsView, animated: true)
            
            break
        case .Notifications:
            // go to question, or do nothing
            break
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

