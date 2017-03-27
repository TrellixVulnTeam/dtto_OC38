//
//  RelatersViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class RelatersViewController: UIViewController {

    var postID: String
    var relaters = [Relater]()
    var relatersRef: FIRDatabaseReference
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 50

        tableView.delegate = self
        tableView.dataSource = self
//        tv.separatorStyle = .none
        tableView.register(RelatersCell.self, forCellReuseIdentifier: "RelatersCell")

        return tableView
    }()
    
    init(postID: String) {
        self.postID = postID
        self.relatersRef = FIREBASE_REF.child("postRelates").child(postID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeRelaters()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        relatersRef.removeAllObservers()
    }
    
    func setupViews() {
        
        title = "Relaters"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func observeRelaters() {
        
        relatersRef.queryOrdered(byChild: "timestamp").observe(.childAdded, with: { snapshot in
            
            if let relaterData = snapshot.value as? Dictionary<String, AnyObject> {
                let relater = Relater(dictionary: relaterData)
                self.relaters.insert(relater, at: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }

}

extension RelatersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relaters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let relater = relaters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelatersCell") as! RelatersCell
        cell.nameLabel.text = relater.name ?? ""
        cell.usernameLabel.text = relater.username ?? ""
        cell.profileImage.loadProfileImage(relater.userID!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let relater = relaters[indexPath.row]
        
        let vc = ProfileViewController(userID: relater.userID!)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
