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
    
    var chats = [Chat]()
    var chatsDictionary = [String:Chat]()
    var requests = [UserNotification]()
    var notifications = [UserNotification]() {
        didSet {
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    var horizontalBarView = UIView()
    var selectedIndex: Int = 1
    var collectionView: UICollectionView!
    var initialLoad = true
    var numberOfMenuTabs = 0
    
    lazy var chatButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "chatNormal"), style: .plain, target: self, action: #selector(scrollToMenuIndex(_:)))
        button.tag = 2
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        setupNavBar()
        setupHorizontalBar()
        setupCollectionView()
        observeChats()
        observeNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
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
            guard let selectedIndexPath = cv.tableView.indexPathsForSelectedRows?.first else { return }
            cv.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        if let cv = collectionView.cellForItem(at: selectedCV) as? NotificationsPage {
            guard let selectedIndexPath = cv.tableView.indexPathsForSelectedRows?.first else { return }
            cv.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        if let cv = collectionView.cellForItem(at: selectedCV) as? HomePage {
            if let selectedIndexPath = cv.tableView.indexPathForSelectedRow {
                cv.tableView.deselectRow(at: selectedIndexPath, animated: true)

            }
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
    
    var timer: Timer?
    
    func attemptReloadOfChats() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloadChats), userInfo: nil, repeats: false)
    }
    
    func handleReloadChats() {
        
        chats = Array(chatsDictionary.values)
        
        chats.sort(by: { (chat1, chat2) -> Bool in
            
            if let timestamp1 = chat1.getTimestamp(), let timestamp2 = chat2.getTimestamp() {
                return timestamp1 > timestamp2
            }
            else {
                return true
            }
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async {
            print("reloaded chats")
            self.collectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
        }
    }

    func observeChats() {
        
        // Check user path for list of chat IDs.
        
        guard let userID = defaults.getUID() else { return }

        let userChatsRef = USERS_REF.child(userID).child(CHATS_CHILD)
        
        userChatsRef.observe(.childAdded, with: { snapshot in
        
            let chatID = snapshot.key
            let chatRoomRef = CHATS_REF.child(chatID)

            chatRoomRef.observe(.value, with: { chatSnapshot in
                
                if let chat = Chat(snapshot: chatSnapshot){
                    self.chatsDictionary.updateValue(chat, forKey: chat.getChatID())
                    self.attemptReloadOfChats()
                }
                
            })
        })
        
        userChatsRef.observe(.childRemoved, with: { snapshot in
            
            let chatIDRemoved = snapshot.key
            
            // remove observer
            MESSAGES_REF.child(chatIDRemoved).removeAllObservers()
            
            self.chatsDictionary.removeValue(forKey: chatIDRemoved)
            self.attemptReloadOfChats()

        })
        
    }
    
    private func observeNotifications() {
        
        guard let userID = defaults.getUID() else { return }
        let notificationsRef = USERS_REF.child(userID).child("notifications")
        notificationsRef.observe(.childAdded, with: { snapshot in
            
            if let notification = UserNotification(snapshot: snapshot) {
                DispatchQueue.main.async {
                    self.notifications.insert(notification, at: 0)
                    self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                }
            }

        })
        
        notificationsRef.observe(.childRemoved, with: { snapshot in
            
            let notificationID = snapshot.key
            
            for (index, notification) in self.notifications.enumerated() {
                if notification.getNotificationID() == notificationID {
                    DispatchQueue.main.async {
                        self.notifications.remove(at: index)
                        self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                    }
                }
            }
            
        })
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
        
        navigationItem.leftBarButtonItem = notificationsButton
        navigationItem.rightBarButtonItem = chatButton
        
        let homeButton =  UIButton(type: .custom)
        homeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        homeButton.setTitleColor(Color.darkNavy, for: .normal)
        homeButton.setTitle("dtto", for: UIControlState.normal)
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
        collectionView.bounces = false
        collectionView.allowsSelection = false
        
        view.addSubview(collectionView)

        collectionView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(NotificationsPage.self, forCellWithReuseIdentifier: "NotificationsPage")
        collectionView.register(HomePage.self, forCellWithReuseIdentifier: "HomePage")
        collectionView.register(ChatList.self, forCellWithReuseIdentifier: "ChatList")
        
    }
    
    func scrollToMenuIndex(_ sender: AnyObject) {
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        selectedIndex = sender.tag
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sliderBarCenterXAnchorConstraint?.constant = scrollView.contentOffset.x/2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        selectedIndex = Int(index)
    }
    
    func scrollToIndex() {
        switch selectedIndex {
        case 0:
            sliderBarCenterXAnchorConstraint?.constant = 25
            
        case 1:
            sliderBarCenterXAnchorConstraint?.constant = SCREENWIDTH/2
            
        default:
            sliderBarCenterXAnchorConstraint?.constant = SCREENWIDTH - 25
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
        case notifications
        case home
        case chat
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
            
        case .notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsPage", for: indexPath) as! NotificationsPage
            cell.notifications = notifications
            cell.masterViewDelegate = self
            return cell
            
        case .home:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePage", for: indexPath) as! HomePage
            cell.masterViewDelegate = self
            return cell

        case .chat:
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
