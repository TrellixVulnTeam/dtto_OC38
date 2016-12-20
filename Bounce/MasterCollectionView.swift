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
    private lazy var chatRef: FIRDatabaseReference = FIRDatabase.database().reference().child("userMessages")
    private var chats = [Chat]()
    
    var horizontalBarView = UIView()
    var selectedIndex: Int = 0
    var numberOfMenuTabs = 0
    var abilityType = ""
    var abilityTitle = ""
    var collectionView: UICollectionView!
    var initialLoad = true
    var reuseIdentifier = ""
    var abilityNames = [String]()

    
    var group = DispatchGroup()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.numberOfMenuTabs = 3
//        self.reuseIdentifier = "AbilityListTableCell"
        self.navigationItem.title = "Home"
        
    }
    
    /*
    init(abilityType: (String, String), selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        menuType = .AbilityView
        self.abilityType = abilityType.1
        self.selectedIndex = selectedIndex
        downloadArray()
        self.numberOfMenuTabs = 5
        self.reuseIdentifier = "AbilityViewTableCell"
        self.title = abilityType.0
        setupMenuBar()
        
    }
    
    init(menuType: menuType) {
        super.init(nibName: nil, bundle: nil)
        
        // should be tavernView
        self.numberOfMenuTabs = 3
        self.menuType = menuType
        self.reuseIdentifier = "TavernListTableCell"
        self.title = "주점"
        setupMenuBar()
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let refHandle = chatRefHandle {
            chatRef.removeObserver(withHandle: refHandle)
            print("DEINITED")
        }
    }
    
    private func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        
        let userID = "uid1"
        chatRefHandle = chatRef.child(userID).observe(.childAdded, with: { (snapshot) -> Void in
            let userChats = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = userChats["lastMessage"] as! String!, let timeStamp = userChats["timeStamp"] as! String! {
//                self.channels.append(Channel(id: id, name: name))
//                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
//        self.title = abilityType
        
        setupNavBar()
        setupHorizontalBar()
        setupCollectionView()
        observeChannels()
        
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationController?.hidesBarsOnSwipe = true
        horizontalBarView.isHidden = false
        if initialLoad {
            collectionView.contentOffset.x = SCREENWIDTH
            initialLoad = false
        }
        
        let selectedCV = IndexPath(item: selectedIndex, section: 0)
        guard let cv = collectionView.cellForItem(at: selectedCV) as? ChatList else { return }
        guard let selectedIndexPath = cv.collectionView.indexPathsForSelectedItems?.first else { return }
        cv.collectionView.deselectItem(at: selectedIndexPath, animated: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        horizontalBarView.isHidden = true
        
    }
    
    var horizontalBarLeadingAnchorConstraint: NSLayoutConstraint?
    var horizontalBarWidthConstraint: NSLayoutConstraint?
    var sliderBarCenterXAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        
        guard let nav = self.navigationController else { return }
        horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.darkNavy
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        nav.view.addSubview(horizontalBarView)

        sliderBarCenterXAnchorConstraint = horizontalBarView.centerXAnchor.constraint(equalTo: nav.view.leadingAnchor)
        sliderBarCenterXAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: nav.navigationBar.bottomAnchor).isActive = true

        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: 50)
        horizontalBarWidthConstraint?.isActive = true
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 1).isActive = true

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
        
        self.view.addSubview(collectionView)
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        collectionView.register(NotificationsPage.self, forCellWithReuseIdentifier: "NotificationsPage")
        collectionView.register(HomePage.self, forCellWithReuseIdentifier: "HomePage")
        collectionView.register(ChatList.self, forCellWithReuseIdentifier: "ChatList")
    }
    
    func scrollToMenuIndex(_ sender: AnyObject) {
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.selectedIndex = sender.tag
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        
    }
    
    var previousOffset: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let difference = scrollView.contentOffset.x - previousOffset
//        horizontalBarLeadingAnchorConstraint?.constant = scrollView.contentOffset.x/2
        sliderBarCenterXAnchorConstraint?.constant = scrollView.contentOffset.x/2
        previousOffset = scrollView.contentOffset.x
      
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfMenuTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Section(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        switch row {
            
        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsPage", for: indexPath) as! NotificationsPage
            return cell
            
        case .Home:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePage", for: indexPath) as! HomePage

            return cell

        case .Chat:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatList", for: indexPath) as! ChatList
            
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
