//
//  PostsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PostsViewController: BaseTableViewController, PostProtocol {

    var posts = [Post]()
    var fullPosts = [Post]()
    var outgoingRequests: [String : Bool]?
    var relates: [String : Bool]?
    var initialLoad = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        observePosts()
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostProfileCell.self, forCellReuseIdentifier: "PostProfileCell")
        tableView.register(PostTextCell.self, forCellReuseIdentifier: "PostTextCell")
        tableView.register(PostButtonsCell.self, forCellReuseIdentifier: "PostButtonsCell")
        tableView.register(PostTagsCell.self, forCellReuseIdentifier: "PostTagsCell")
        
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
    }
    
    private func observePosts() {
        
        let postsRef = FIREBASE_REF.child("posts")
        
        postsRef.observe(.childAdded, with: { snapshot in
            
            if let postData = snapshot.value as? Dictionary<String, AnyObject> {
                
                if let post = Post(dictionary: postData) {
                    self.posts.insert(post, at: 0)
                    self.fullPosts.insert(post, at: 0)
                    
                    if self.initialLoad == false {
                        self.tableView.beginUpdates()
                        self.tableView.insertSections(IndexSet(integer: 0), with: .automatic)
                        self.tableView.endUpdates()
                    }
                }
            }
            
        })
        
        postsRef.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.tableView.reloadData()
        })
        
    }


    func requestChat(cell: PostButtonsCell, chatState: ChatState) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let post = posts[indexPath.section]
        let postID = post.getPostID()
        let posterID = post.getUserID()
        guard let userID = defaults.getUID(), posterID != userID else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let chatRequestRef = FIREBASE_REF.child("requests").child(posterID).child(postID).child(userID)
        
        
        switch chatState {
            
        case .normal:
            
            cell.chatState = .requested
            chatRequestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                // if poster ignored this user, do nothing on server.
                if !snapshot.exists() {
                    
                    dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(posterID)/requestsCount"))
                    dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(posterID).child("totalChatRequestsCount"))
                    
                    let request: [String: Any] = [
                        "name": "Jae",
                        "postID" : postID,
                        "timestamp" : "11-11",
                        "senderID" : userID,
                        "pending" : true
                    ]
                    
                    chatRequestRef.setValue(request)
                }
                
            })
            
        case .requested:
            
            cell.chatState = .normal
            chatRequestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                // if poster has not ignored yet, cancel the request.
                if snapshot.exists() {
                    guard let pending = snapshot.value as? Bool else { return }
                    if pending {
                        dataRequest.decrementCount(ref: FIREBASE_REF.child("users/\(posterID)/requestsCount"))
                        dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(posterID).child("totalChatRequestsCount"))
                        chatRequestRef.removeValue()
                        
                    }
                }
                else {
                    
                }
                
                
            })
            
        case .ongoing:
            print("Already in chat, doing nothing...")
            // maybe go to the chat?
            break
        }
        
    }
    
    func relatePost(cell: PostButtonsCell) {
        
        guard let section = tableView.indexPath(for: cell)?.section else { return }
        
        let post = posts[section]
        let postID = post.getPostID()
        let friendID = post.getUserID()
        guard let userID = defaults.getUID(), let username = defaults.getUsername(), let name = defaults.getName() else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let postRelatesRef = FIREBASE_REF.child("postRelates").child(postID).child(userID)
        
        let userRelatesRef = FIREBASE_REF.child("users/\(userID)/relatedPosts").child(postID)
        userRelatesRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                userRelatesRef.removeValue()
                dataRequest.decrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
                
                // remove this user from the post's list of related users
                postRelatesRef.removeValue()
                _ = self.relates?.removeValue(forKey: postID)
            }
            else {
                userRelatesRef.setValue(true)
                dataRequest.incrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
                
                // add this user to the post's list of related users
                let timestamp = Date()
                let relaterData: [String : Any] = ["name" : name, "username" : username, "timestamp" : "\(timestamp)"]
                postRelatesRef.setValue(relaterData)
                _ = self.relates?.updateValue(true, forKey: postID)
            }
            
            if let relates = self.relates {
                defaults.setRelates(value: relates)
            }
            
        })
        
    }
    
    func sharePost(cell: PostButtonsCell) {
        
    }
    
    func showMore(cell: PostProfileCell, sender: AnyObject) {
        
        guard let button = sender as? UIView, let section = tableView.indexPath(for: cell)?.section else { return }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy
        
        let post = posts[section]
        let posterID = post.getUserID()
        if let userID = defaults.getUID() {
            
            if userID == posterID {
                
                let delete = UIAlertAction(title: "Delete", style: .default, handler: { [unowned self] (action:UIAlertAction) in
                    
                    self.deletePost(section: section)
                    
                })
                
                ac.addAction(delete)
                
                let edit = UIAlertAction(title: "Edit", style: .default, handler: { [unowned self] (action:UIAlertAction) in
                    
                    self.editPost(section: section)
                    
                })
                
                ac.addAction(edit)
                
            }
            else {
                let report = UIAlertAction(title: "Report", style: .destructive, handler: { [unowned self] (action:UIAlertAction) in
                    
                    self.reportPost(postID: post.postID)
                    
                })
                ac.addAction(report)
            }
        }
        
        let hide = UIAlertAction(title: "Hide", style: .default, handler: { [unowned self] (action:UIAlertAction) in
            
            self.hidePost(section: section, postID: post.postID)
            
        })
        ac.addAction(hide)
        
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alertAction: UIAlertAction!) in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = ac.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        present(ac, animated: true, completion: { () -> () in
            ac.view.tintColor = Color.darkNavy
        })
        
    }
    
    func editPost(section: Int) {
        
        let post = posts[section]
        let editPostVC = ComposePostViewController(post: post)
        
        present(UINavigationController(rootViewController:editPostVC), animated: true, completion: nil)
        
    }
    
    func deletePost(section: Int) {
        
        let post = posts[section]
        let postID = post.getPostID()
        let posterID = post.getUserID()
        
        guard let userID = defaults.getUID() else { return }
        if posterID == userID {
            let postRef = FIREBASE_REF.child("posts").child(postID)
            postRef.removeValue()
            print("Removed post.")
            
            // Update user stats
            let userRef = FIREBASE_REF.child("users").child(userID)
            let dataRequest = FirebaseService.dataRequest
            dataRequest.decrementCount(ref: userRef.child("postCount"))
        }
        
        
    }
    
    func hidePost(section: Int, postID: String?) {
        
        if let postID = postID {
            
            defaults.hidePost(postID: postID)
            
            self.tableView.beginUpdates()
            self.posts.remove(at: section)
            self.tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            self.tableView.endUpdates()
        }
        
    }
    
    func reportPost(postID: String?) {
        
        if let postID = postID {
            
            let dataRequest = FirebaseService.dataRequest
            let reportsRef = FIREBASE_REF.child("reports").child(postID)
            dataRequest.incrementCount(ref: reportsRef.child("reportsCount"))
            
        }
    }

    func doubleTapped(_ gestureReconizer: UITapGestureRecognizer) {
        
        let p = gestureReconizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            guard let _ = tableView.cellForRow(at: index) as? PostTextCell else { return }
            guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: index.section)) as? PostButtonsCell else { return }
            // request chat to this user
            cell.requestChat(cell.chatButton)
            //            requestChat(row: index.row, chatState: cell.chatState)
            
        } else {
            print("Could not find index path")
        }
    }

    func showProfile(section: Int) {
        
        let post = posts[section]
        let profileVC = ProfileViewController(userID: post.getUserID())
        
        masterViewDelegate?.navigationController?.pushViewController(profileVC, animated: true)
        
    }

}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case profile
        case post
        case buttons
        case relates
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        if post.getRelatesCount() < 1 {
            return 3
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        let post = posts[indexPath.section]
        
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
            
            cell.postDelegate = self
            return cell
            
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTextCell") as! PostTextCell
            cell.postLabel.text = post.text!
            return cell
            
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostButtonsCell") as! PostButtonsCell
            
            cell.requestChatDelegate = self
            
            if let _ = relates?[post.getPostID()] {
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
                if let ongoing = outgoingRequests?[post.getPostID()] {
                    if ongoing {
                        cell.chatState = .ongoing
                    }
                    else {
                        cell.chatState = .requested
                    }
                }
                else {
                    cell.chatState = .normal
                }
            }
            
            return cell
            
        case .relates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTagsCell") as! PostTagsCell
            
            cell.relatesCount = post.getRelatesCount()
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let row = Row(rawValue: indexPath.row) else { return nil }
        
        switch row {
        case .profile:
            // if post.isanonymous = false
            let post = posts[indexPath.section]
            if post.isAnonymous {
                return nil
            }
            else {
                return indexPath
            }
        case .post:
            // double tap action
            return nil
        case .buttons:
            return nil
        case .relates:
            return indexPath
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        let post = posts[indexPath.section]
        switch row {
        case .profile:
            
            if !post.isAnonymous {
                showProfile(section: indexPath.section)
            }
            
        case .relates:
            let vc = RelatersViewController(postID: post.getPostID())
            masterViewDelegate?.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        guard let row = Row(rawValue: indexPath.row) else { return false }
        
        switch row {
        case .profile, .relates:
            return true
        default:
            return false
        }
        
    }
}

extension PostsViewController: UIGestureRecognizerDelegate {
    
}
