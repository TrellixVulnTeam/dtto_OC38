//
//  PostViewController.swift
//  dtto
//
//  Created by Jitae Kim on 5/3/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    let postID: String
    var post: Post?
    var related = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var chatState: ChatState = .normal {
        didSet {
            self.tableView.reloadData()
        }
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    init(postID: String) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
        observePost()
        checkRelate()
        checkChat()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func observePost() {
        
        let postRef = POSTS_REF.child(postID)
        postRef.observe(.value, with: { snapshot in
            
            if let post = Post(snapshot: snapshot) {
                
                DispatchQueue.main.async {
                    
                    self.post = post
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
    func checkRelate() {
        
        guard let userID = defaults.getUID() else { return }
        USERS_REF.child(userID).child("relatedPosts").child(postID).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                // user related to this post.
                self.related = true
            }
            else {
                self.related = false
            }
            
        })
    }
    
    func checkChat() {
        
        guard let userID = defaults.getUID() else { return }
        
        USERS_REF.child(userID).child("ongoingPostChats").child(postID).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists(){
                // user already in chat
                self.chatState = .ongoing
                return
            }
            
        })
        
        USERS_REF.child(userID).child("ongoingPostChats").child(postID).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists(){
                // user already in chat
                self.chatState = .ongoing
                return
            }
            
        })
        
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case profile
        case post
        case buttons
        case relates
//        case comments
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let post = post else { return 0 }
        if post.getRelatesCount() < 1 {
            return 3
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row), let post = post else { return UITableViewCell() }
        
        switch row {
            
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostProfileCell") as! PostProfileCell
            
            cell.profileImage.image = nil
            
            //            cell.nameLabel.text = post.name ?? "Anonymous"
            
            // Only load profile if the post is public
            
            if post.isAnonymous {
                cell.profileImage.backgroundColor = Color.lightGray
                cell.usernameLabel.text = "Anonymous"
            }
            else {
                if let username = post.getPostUsername() {
                    cell.profileImage.loadProfileImage(post.getUserID())
                    cell.usernameLabel.text = username
                }
            }
            
//            cell.postDelegate = self
            return cell
            
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTextCell") as! PostTextCell
            cell.postLabel.text = post.text!
            return cell
            
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostButtonsCell") as! PostButtonsCell
            
//            cell.requestChatDelegate = self
            
            if related {
                cell.relateButton.isSelected = true
            }
            else {
                cell.relateButton.isSelected = false
            }
            
            if post.getUserID() == defaults.getUID() {
                cell.chatButton.isHidden = true
            }
            else {
                cell.chatButton.isHidden = false
                cell.chatState = self.chatState
            }
            
            return cell
            
        case .relates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTagsCell") as! PostTagsCell
            
            cell.relatesCount = post.getRelatesCount()
            return cell
            
        }

    }
    
}
