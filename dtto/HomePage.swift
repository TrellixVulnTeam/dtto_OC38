//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol PostProtocol : class {
    func viewComments(cell: PostButtonsCell)
    func requestChat(cell: PostButtonsCell, chatState: ChatState)
    func relatePost(cell: PostButtonsCell)
    func sharePost(cell: PostButtonsCell)
    func showMore(cell: PostProfileCell, sender: AnyObject)
}


class HomePage: BaseCollectionViewCell, PostProtocol {
    
    var posts = [Post]()
    var fullPosts = [Post]()
    var outgoingRequests = [String : Bool]()    // true means request is pending. false means chat is ongoing.
    var outgoingRelates = [String : Bool]()
    var initialLoad = true
    
    override func setupViews() {
        super.setupViews()
        
        observeOutgoingRequests()
        observeOutgoingRelates()
        observePosts()
//        observeComments()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostProfileCell.self, forCellReuseIdentifier: "PostProfileCell")
        tableView.register(PostTextCell.self, forCellReuseIdentifier: "PostTextCell")
        tableView.register(PostButtonsCell.self, forCellReuseIdentifier: "PostButtonsCell")
        tableView.register(PostRelatesCell.self, forCellReuseIdentifier: "PostRelatesCell")
        tableView.register(CommentsTableView.self, forCellReuseIdentifier: "CommentsTableView")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
    }
    
    
    private func observeOutgoingRequests() {
        
        guard let userID = defaults.getUID() else { return }
        
        var initialLoad = true
        
        let outgoingRequestsRef = USERS_REF.child(userID).child("outgoingRequests")

        outgoingRequestsRef.observe(.childAdded, with: { snapshot in
        
            let postID = snapshot.key
            
            if let requestDict = snapshot.value as? [String:String], let requestID = requestDict["requestID"], let posterID = requestDict["receiverID"] {
                
                let friendRequestsRef = REQUESTS_REF.child(posterID).child(requestID)
                friendRequestsRef.child("pending").observe(.value, with: { snapshot in
                    
                    // find the post to update
                    for (index, post) in self.posts.enumerated() {
                        if post.getPostID() == postID {
                            DispatchQueue.main.async {
                                
                                if snapshot.exists() {
                                    // regardless of whether it is pending, or ignored, post should have requested chat state.
                                    self.outgoingRequests.updateValue(true, forKey: postID)
                                }
                                else {
                                    // if snapshot doesn't exist, the other user already accepted this request, so this post should have ongoing chat state.
                                    self.outgoingRequests.updateValue(false, forKey: postID)
                                }
                                
                                if !initialLoad {
                                    self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                                }
                            }
                        }
                    }
                
                })
            }
            
        })
        
        outgoingRequestsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            initialLoad = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("found all outGoingRequests. reloading tableview.")
            }

        })
        
        // child will be removed when the user deletes chat
        outgoingRequestsRef.observe(.childRemoved, with: { snapshot in
            
            let postID = snapshot.key
            
            for (index, post) in self.posts.enumerated() {
                if post.getPostID() == postID {
                    DispatchQueue.main.async {
                        self.outgoingRequests.removeValue(forKey: postID)
                        self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                    }
                }
            }
        })
        
    }
    
    private func observeOutgoingRelates() {
        
        guard let userID = defaults.getUID() else { return }
        
        var initialLoad = true
        
        let relatedPostsRef = USERS_REF.child(userID).child("relatedPosts")
        relatedPostsRef.observe(.childAdded, with: { snapshot in
            
            DispatchQueue.main.async {
                self.outgoingRelates.updateValue(true, forKey: snapshot.key)
                if !initialLoad {
                    // reload tableview at index.
                    for (index, post) in self.posts.enumerated() {
                        if post.getPostID() == snapshot.key {
                            self.tableView.reloadSections(IndexSet(integer: index), with: .none)
                        }
                    }
                }
            }
            
            
        })
        
        relatedPostsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            initialLoad = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("found all related posts. reloading tableview.")
            }
            
        })
        
        relatedPostsRef.observe(.childRemoved, with: { snapshot in
            
            DispatchQueue.main.async {
                self.outgoingRelates.removeValue(forKey: snapshot.key)
                // reload tableview at index.
                for (index, post) in self.posts.enumerated() {
                    if post.getPostID() == snapshot.key {
                        self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                    }
                }
            }
            
        })
        
    }
    
    private func observePosts() {
        
        let postsRef = FIREBASE_REF.child("posts")
        
        postsRef.observe(.childAdded, with: { snapshot in
            
            if let post = Post(snapshot: snapshot) {
    
                DispatchQueue.main.async {
                    
                    self.fullPosts.insert(post, at: 0)
                    self.posts.insert(post, at: 0)

                    if self.initialLoad == false {
                        self.tableView.insertIndexPathAt(index: 0)
                    }
                }
            }
            
        })
        
        postsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            DispatchQueue.main.async {
                self.initialLoad = false
                self.tableView.reloadData()
                print("found all posts. reloading tableview.")
            }
        })
        
        postsRef.observe(.childChanged, with: { snapshot in
            
            let postID = snapshot.key
            
            for (index, post) in self.posts.enumerated() {
                if post.getPostID() == postID {
                    
                    if let post = Post(snapshot: snapshot) {
                        DispatchQueue.main.async {
                            self.posts[index] = post
                            self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                        }
                    }
                }
            }
            
        })
        
        postsRef.observe(.childRemoved, with: { snapshot in
            
            let postID = snapshot.key
            
            for (index, post) in self.posts.enumerated() {
                
                if post.getPostID() == postID {
                    DispatchQueue.main.async {
                        self.posts.remove(at: index)
                        self.fullPosts.remove(at: index)
                        self.tableView.deleteIndexPathAt(index: index)
                    }
                }
                
            }
        })
        
    }
    
    func observeRecentComments() {
        
        
    }
    
    var timer: Timer?
    
    func attemptReloadOfChats() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloadPosts), userInfo: nil, repeats: false)
    }
    
    func handleReloadPosts() {
        
        DispatchQueue.main.async {
            print("successfully reloaded posts.")
            self.tableView.reloadData()
        }
    }
    
    func viewComments(cell: PostButtonsCell) {
        
        guard let section = tableView.indexPath(for: cell)?.section else { return }
        
        let post = posts[section]
        
        let vc = CommentsViewController(post: post)
        masterViewDelegate?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func requestChat(cell: PostButtonsCell, chatState: ChatState) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let post = posts[indexPath.section]
        let postID = post.getPostID()
        let posterID = post.getUserID()
        guard let userID = defaults.getUID(), posterID != userID else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let autoID = FIREBASE_REF.child("requests").child(posterID).childByAutoId().key

        // The other user is listening for changes at chatRequestRef
        let chatRequestRef = FIREBASE_REF.child("requests").child(posterID).child(autoID)
        
        // Keep track of this user's sent requests, so we can update the requestChat button in HomePage.
        let outgoingRequestsRef = USERS_REF.child(userID).child("outgoingRequests").child(postID)

        switch chatState {
            
        case .normal:

            cell.chatState = .requested
            outgoingRequestsRef.child("requestID").observeSingleEvent(of: .value, with: { snapshot in
                
                if let requestID = snapshot.value as? String {
                    
                    // user requested chat before, check if it is pending, or was accepted.
                    let requestRef = FIREBASE_REF.child("requests").child(posterID).child(requestID)
                    requestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                        
                        // if poster has not ignored yet, cancel the request.
                        guard let pending = snapshot.value as? Bool, pending == true else { return }
                        dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(posterID).child("requestsCount"))
                        dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(posterID).child("totalChatRequestsCount"))
                        requestRef.removeValue()
                        outgoingRequestsRef.removeValue()
                        
                    })
                    
                }
                else {
                    
                    // no snapshot found, so request chat
                    dataRequest.incrementCount(ref: USERS_REF.child(posterID).child("requestsCount"))
                    dataRequest.incrementCount(ref: USERS_REF.child(posterID).child("totalChatRequestsCount"))
                    
                    let request: [String: Any] = [
                        "senderName": "Jae",
                        "postID" : postID,
                        "timestamp" : [".sv" : "timestamp"],
                        "senderID" : userID,
                        "pending" : true
                    ]
                    
                    chatRequestRef.updateChildValues(request)
                    
                    // Setting to true, which means request is pending. Later when the other user accepts, it will be changed to false so that we can indicate that a post chat is ongoing. TODO: when chat is deleted.
                    let outgoingRequest: [String:Any] = [
                        "requestID" : autoID,
                        "receiverID" : posterID
                    ]
                    
                    outgoingRequestsRef.updateChildValues(outgoingRequest)
        
                }

            })
            
            if !defaults.getShowedNotification() {
                masterViewDelegate?.askNotifications()
            }
            
        case .requested:

            cell.chatState = .normal
            
            // get the requestID.
            outgoingRequestsRef.observeSingleEvent(of: .value, with: { snapshot in
                
//                let postID = snapshot.key
                
                if let requestDict = snapshot.value as? [String:String], let requestID = requestDict["requestID"], let posterID = requestDict["receiverID"] {
                    
                    // user requested chat before, check if it is pending, or was accepted.
                    let requestRef = REQUESTS_REF.child(posterID).child(requestID)
                    requestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                        
                        // if poster has not ignored yet, cancel the request.
                        guard let pending = snapshot.value as? Bool, pending == true else { return }
                        dataRequest.decrementCount(ref: USERS_REF.child(posterID).child("requestsCount"))
                        dataRequest.decrementCount(ref: USERS_REF.child(posterID).child("totalChatRequestsCount"))
                        requestRef.removeValue()
                        outgoingRequestsRef.removeValue()
                        
                    })
                    
                }

            })

        case .ongoing:
            print("Already in chat, doing nothing...")
            // maybe go to the chat?
            break
        }
    
    }
    
    func relatePost(cell: PostButtonsCell) {
        
        guard let section = tableView.indexPath(for: cell)?.section,
            let userID = defaults.getUID(),
            let username = defaults.getUsername(),
            let name = defaults.getName() else { return }

        let post = posts[section]
        let friendID = post.getUserID()

        // User should not be able to relate to own post.
        if friendID == userID {
            return
        }

        let postID = post.getPostID()
        
        cell.relateButton.isSelected = !cell.relateButton.isSelected
        
        let dataRequest = FirebaseService.dataRequest
        let postRelatesRef = FIREBASE_REF.child("postRelates").child(postID).child(userID)
        
        let userRelatesRef = USERS_REF.child(userID).child("relatedPosts").child(postID)
        userRelatesRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                if let notificationID = snapshot.value as? String {
                    // remove the notification that was sent to the other user.
                    let notificationRef = USERS_REF.child(friendID).child("notifications").child(notificationID)
                    notificationRef.removeValue()
                }
                dataRequest.decrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
                
                // remove this user from the post's list of related users
                postRelatesRef.removeValue()
                
                // remove this post from the user's relatedPosts
                userRelatesRef.removeValue()
            }
            else {
                userRelatesRef.setValue(true)
                dataRequest.incrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
                
                // add this user to the post's list of related users
                let relaterData: [String : Any] = ["name" : name, "username" : username, "timestamp" : [".sv" : "timestamp"]]
                postRelatesRef.setValue(relaterData)

                // add this post to the user's relatedPosts
                userRelatesRef.setValue(true)
                
            }
            
        })
        
    }
    
    func sharePost(cell: PostButtonsCell) {
        
        // create a URL
        guard let section = tableView.indexPath(for: cell)?.section else { return }
        
        let post = posts[section]
        let postID = post.getPostID()
                
        let vc = UIActivityViewController(activityItems: ["Help out a colleague. https://dtto.com/posts/\(postID)"], applicationActivities: nil)
        masterViewDelegate?.present(vc, animated: true, completion: nil)
    }
    
    func showMore(cell: PostProfileCell, sender: AnyObject) {
        
        guard let button = sender as? UIView, let section = tableView.indexPath(for: cell)?.section else { return }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy
        
        let post = posts[section]
        let posterID = post.getUserID()
        if let userID = defaults.getUID() {
            
            if userID == posterID {
                
                let edit = UIAlertAction(title: "Edit", style: .default, handler: { action in
                    
                    self.editPost(section: section)
                    
                })
                
                ac.addAction(edit)

                let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    
                    self.deletePost(section: section)
                    
                })
                
                ac.addAction(delete)
            }
            else {
                let report = UIAlertAction(title: "Report", style: .destructive, handler: { action in
                    
                    self.reportPost(post)
                    
                })
                ac.addAction(report)
            }
        }

        let hide = UIAlertAction(title: "Hide", style: .default, handler: { action in
            
            self.hidePost(section: section, postID: post.postID)
            
        })
        ac.addAction(hide)
        
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = ac.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        masterViewDelegate?.present(ac, animated: true, completion: { () -> () in
            ac.view.tintColor = Color.darkNavy
        })
        
    }
    
    func editPost(section: Int) {
        
        let post = posts[section]
        let editPostVC = ComposePostViewController(post: post)

        masterViewDelegate?.navigationController?.present(UINavigationController(rootViewController:editPostVC), animated: true, completion: nil)
        
    }
    
    func deletePost(section: Int) {
        
        let post = posts[section]
        let postID = post.getPostID()
        let posterID = post.getUserID()
        
        guard let userID = defaults.getUID() else { return }
        if posterID == userID {
            
            POSTS_REF.child(postID).removeValue()
            print("Removed post.")
            
            // Update user stats
            let userRef = USERS_REF.child(userID)
            let dataRequest = FirebaseService.dataRequest
            dataRequest.decrementCount(ref: userRef.child("postCount"))
            
            // delete comments attached to this post.
//            COMMENTS_REF.child(postID).
        }
        
        
    }
    
    func hidePost(section: Int, postID: String) {
        
        defaults.hidePost(postID)
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.posts.remove(at: section)
            self.tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            self.tableView.endUpdates()
        }
        
    }
    
    func reportPost(_ post: Post) {
        
        guard let userID = defaults.getUID() else { return }
        
        let report = [
            "userID" : post.getUserID(),
            "reporterID" : userID,
            "reason" : "inappropriate"
        ]
        
        REPORTS_REF.child(post.getPostID()).childByAutoId().updateChildValues(report)

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

extension HomePage: UIGestureRecognizerDelegate {
    
}

extension HomePage: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case profile
        case post
        case buttons
        case relates
        case comments
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        
        let post = posts[indexPath.section]
        
        switch row {
        case .relates:
            if post.getRelatesCount() == 0 {
                return 0
            }
        case .comments:
            // TODO: Check # of comments
            if post.getCommentCount() == 0 {
                return 0
            }
            return 50
        default:
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        let post = posts[indexPath.section]
        
        switch row {
            
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostProfileCell") as! PostProfileCell
            
//            cell.profileImage.image = nil
            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            // Only load profile if the post is public
    
            if post.isAnonymous {
                cell.profileImage.backgroundColor = Color.lightGray
                cell.usernameLabel.text = "Anonymous"
            }
            else {
                if let username = post.getPostUsername() {
//                    cell.profileImage.loadProfileImage(post.getUserID())
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
            
            if post.getUserID() == defaults.getUID() {
                // disable components for a user's own post.
                cell.chatButton.isHidden = true
                cell.relateButton.isEnabled = false
            }
            else {
                cell.chatButton.isHidden = false
                cell.relateButton.isEnabled = true
            }

            if let _ = outgoingRelates[post.getPostID()] {
                cell.relateButton.isSelected = true
            }
            else {
                cell.relateButton.isSelected = false
            }
            
            if let pending = outgoingRequests[post.getPostID()] {
                if pending {
                    cell.chatState = .requested
                }
                else {
                    cell.chatState = .ongoing
                }
            }
            else {
                cell.chatState = .normal
            }

            return cell
            
        case .relates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostRelatesCell") as! PostRelatesCell
            
            cell.relatesCount = post.getRelatesCount()
            return cell
            
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableView") as! CommentsTableView
            cell.post = post
//            cell.comments = self.comments
            cell.navigationDelegate = masterViewDelegate?.navigationController
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
        case .comments:
            // TODO: Push Comments VC
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
