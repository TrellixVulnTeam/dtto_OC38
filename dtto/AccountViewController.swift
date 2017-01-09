//
//  AccountViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate {

    var user: User?
    var horizontalBarView = UIView()
    let menuBar = MenuBar()
    let headerView = AccountProfileHeader()
    var topConstraint: NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(AccountPostsTableView.self, forCellWithReuseIdentifier: "AccountPostsTableView")
        return collectionView
        
    }()

    private func observeUser() {
        print("GETTING USER INFO...")
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let userRef = FIREBASE_REF.child("users/\(userID)")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            
            
        })
        
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        headerView.backgroundColor = .yellow
        view.addSubview(headerView)
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        
        headerView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        
        topConstraint = headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        topConstraint?.isActive = true
        
        menuBar.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        collectionView.anchor(top: menuBar.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView == (collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! AccountPostsTableView).tableView {
            print("SCROLLING TABLEVIEW")
//            scrollView.isScrollEnabled = false
        }
        
        topConstraint?.constant = -scrollView.contentOffset.y
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > 100 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint?.constant = -110
                self.view.layoutIfNeeded()
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeUser()
        setupViews()
    }

}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountPostsTableView", for: indexPath) as! AccountPostsTableView
        cell.tableView.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
