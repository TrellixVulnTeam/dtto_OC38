//
//  AbilityListCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class MasterCollectionView: UIViewController {
    
    private var chatRefHandle: FIRDatabaseHandle?
    private lazy var chatRef: FIRDatabaseReference = FIRDatabase.database().reference().child("chats")
    private lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("users")
    
    var chats = [Chat]()
    var requests = [UserNotification]()
    var relates = [UserNotification]()
    
    var horizontalBarView = UIView()
    var selectedIndex: Int = 0
    var collectionView: UICollectionView!
    var initialLoad = true
    var numberOfMenuTabs = 0
    
    var group = DispatchGroup()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.numberOfMenuTabs = 3
        self.navigationItem.title = "Home"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        if let refHandle = chatRefHandle {
//            chatRef.removeObserver(withHandle: refHandle)
//            print("DEINITED")
//        }
//    }
    
    func observeChats() {
        
        // Check user path for list of chat IDs.
        
        guard let userID = defaults.getUID() else { return }

        let userChatsRef = FIREBASE_REF.child("users/\(userID)/chats")
        
        userChatsRef.observe(.childAdded, with: { snapshot in
        
            let chatID = snapshot.key
            
            let chatRoomRef = FIREBASE_REF.child("chats/\(chatID)")
        

            chatRoomRef.observe(.value, with: { chatSnapshot in

                let chat = Chat(snapshot: chatSnapshot)
                // insert
                self.chats.insert(chat, at: 0)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    print("Reloaded master")
                }
                
            })
            
            
        })  
        
    }
    
    private func observeNotifications() {
        
        let notificationsRef = FIREBASE_REF.child("relatesNotifications/uid1")
        notificationsRef.observe(.childAdded, with: { snapshot in
            
            guard let userNotifications = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            guard let uid = userNotifications["uid"] as? String, let notificationID = userNotifications["notificationID"] as? String, let name = userNotifications["name"] as? String, let postID = userNotifications["postID"] as? String, let timestamp = userNotifications["timestamp"] as? String else { return }
            
            let notification = UserNotification()
            
            notification.name = name
            notification.postID = postID
            notification.userID = uid
            notification.notificationID = notificationID
            // process timestamp
            notification.timestamp = timestamp
            if let profileImageURL = userNotifications["profileImageURL"] as? String {
                notification.profileImageURL = profileImageURL
            }

            self.relates.append(notification)

            
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        
        setupNavBar()
        setupHorizontalBar()
        setupCollectionView()
        observeChats()
//        observeNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationController?.hidesBarsOnSwipe = true
        UIView.animate(withDuration: 0.2, animations: {
            self.horizontalBarView.alpha = 1
        })
        
        if initialLoad {
            collectionView.contentOffset.x = SCREENWIDTH
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.alpha = 1
            })
            initialLoad = false
        }
        
        let selectedCV = IndexPath(item: selectedIndex, section: 0)

        if let cv = collectionView.cellForItem(at: selectedCV) as? ChatList {
            guard let selectedIndexPath = cv.collectionView.indexPathsForSelectedItems?.first else { return }
            cv.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        else if let cv = collectionView.cellForItem(at: selectedCV) as? NotificationsPage {
            guard let selectedIndexPath = cv.collectionView.indexPathsForSelectedItems?.first else { return }
            cv.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        else if let cv = collectionView.cellForItem(at: selectedCV) as? HomePage {
            guard let selectedIndexPath = cv.collectionView.indexPathsForSelectedItems?.first else { return }
            cv.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        horizontalBarView.alpha = 0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if initialLoad {
            _ = collectionView.collectionViewLayout.collectionViewContentSize
            collectionView.contentOffset.x = SCREENWIDTH
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.alpha = 1
            })
            initialLoad = false
        }
    }
    
    var sliderBarCenterXAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        
        guard let nav = self.navigationController else { return }
        horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.darkNavy
        
        nav.view.addSubview(horizontalBarView)
        
        horizontalBarView.anchor(top: nil, leading: nil, trailing: nil, bottom: nav.navigationBar.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 1)

        sliderBarCenterXAnchorConstraint = horizontalBarView.centerXAnchor.constraint(equalTo: nav.view.leadingAnchor)
        sliderBarCenterXAnchorConstraint?.isActive = true
        
//        nav.navigationBar.layoutIfNeeded()

//        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: 50)
//        horizontalBarWidthConstraint?.isActive = true
        
    }

    
    private func setupNavBar() {
        
        let notificationsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(scrollToMenuIndex(_:)))
        notificationsButton.tag = 0
        
        let chatButton = UIBarButtonItem(image: #imageLiteral(resourceName: "chatNormal"), style: .plain, target: self, action: #selector(scrollToMenuIndex(_:)))
        chatButton.tag = 2
        
        self.navigationItem.leftBarButtonItem = notificationsButton
        self.navigationItem.rightBarButtonItem = chatButton
        
        let homeButton =  UIButton(type: .custom)
        homeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        homeButton.setTitleColor(Color.darkNavy, for: .normal)
        homeButton.setTitle("Dtto", for: UIControlState.normal)
        homeButton.addTarget(self, action: #selector(scrollToMenuIndex(_:)), for: UIControlEvents.touchUpInside)
        homeButton.tag = 1
        self.navigationItem.titleView = homeButton
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    // MARK: UICollectionViewDataSource
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.alpha = 0
        
        self.view.addSubview(collectionView)

        collectionView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(NotificationsPage.self, forCellWithReuseIdentifier: "NotificationsPage")
        collectionView.register(HomePage.self, forCellWithReuseIdentifier: "HomePage")
        collectionView.register(ChatList.self, forCellWithReuseIdentifier: "ChatList")
    }
    
    func scrollToMenuIndex(_ sender: AnyObject) {
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.selectedIndex = sender.tag
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sliderBarCenterXAnchorConstraint?.constant = scrollView.contentOffset.x/2
      
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        self.selectedIndex = Int(index)
    }
    
    func scrollToIndex() {
        switch self.selectedIndex {
        case 0:
            self.sliderBarCenterXAnchorConstraint?.constant = 25
            
        case 1:
            self.sliderBarCenterXAnchorConstraint?.constant = SCREENWIDTH/2
            
        default:
            self.sliderBarCenterXAnchorConstraint?.constant = SCREENWIDTH - 25
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.navigationController?.view.layoutIfNeeded()
        }, completion: nil)
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToIndex()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollToIndex()
    }
    

    
}

extension MasterCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private enum Section: Int {
        
        case Notifications
        case Home
        case Chat
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfMenuTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Section(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        switch row {
            
        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsPage", for: indexPath) as! NotificationsPage
            cell.masterViewDelegate = self
            return cell
            
        case .Home:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePage", for: indexPath) as! HomePage
            cell.masterViewDelegate = self
            return cell

        case .Chat:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatList", for: indexPath) as! ChatList
            cell.chats = chats
            cell.masterViewDelegate = self
            return cell
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    
    
    
}

extension MasterCollectionView: UIGestureRecognizerDelegate {
    
}
