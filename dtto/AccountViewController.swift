//
//  AccountViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    var user: User?
    var horizontalBarView = UIView()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = true
        tv.backgroundColor = .white
//        tv.allowsSelection = false
        tv.separatorStyle = .none
        let header = AccountProfileHeader()
        header.frame = .init(x: 0, y: 0, width: SCREENWIDTH, height: 100)
        tv.tableHeaderView = header
        
        tv.register(AccountStatsCollectionView.self, forCellReuseIdentifier: "AccountStatsCollectionView")
        
        return tv
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
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeUser()
        setupViews()
    }

}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    private enum Section: Int {
//        case Profile
//        case Stats
//    }
//    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        guard let section = Section(rawValue: section) else { return nil }
//        
//        switch section {
//        case .Profile:
//            return nil
//        case .Stats:
            return MenuBar()
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        guard let section = Section(rawValue: section) else { return 0 }
//        
//        switch section {
//        case .Profile:
//            return 0
//        case .Stats:
            return 50
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height - 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
//        switch section {
//            
//        case .Profile:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountProfileCell") as! AccountProfileCell
//            cell.nameLabel.text = "Jitae"
//            cell.displayNameLabel.text = "@jitae"
//            cell.relatesReceivedCountLabel.text = "22"
//            cell.profileImage.image = #imageLiteral(resourceName: "profile")
//            return cell
//            
//        case .Stats:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountStatsCollectionView") as! AccountStatsCollectionView
            return cell

        
//        }
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.preservesSuperviewLayoutMargins = false
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
//    }
    

}
