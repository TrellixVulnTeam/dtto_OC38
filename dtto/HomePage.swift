//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol PostProtocol : class {
    func requestChat(cell: PostButtonsCell, chatState: ChatState)
    func relatePost(cell: PostButtonsCell)
    func showMore(cell: PostProfileCell, sender: AnyObject)
}

class HomePage: BaseCollectionViewCell, PostProtocol {
    
    var posts = [Post]()
    var fullPosts = [Post]()
    var outgoingRequests: [String : Bool]?
    var relates: [String : Bool]?
//    var relates: [String : Bool] = defaults.getRelates()
    var initialLoad = true
    
    override func setupViews() {
        super.setupViews()
        
        observePosts()
//        checkOutgoingRequests()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostProfileCell.self, forCellReuseIdentifier: "PostProfileCell")
        tableView.register(PostTextCell.self, forCellReuseIdentifier: "PostTextCell")
        tableView.register(PostButtonsCell.self, forCellReuseIdentifier: "PostButtonsCell")
        tableView.register(PostTagsCell.self, forCellReuseIdentifier: "PostTagsCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
    }
    
    private func checkOutgoingRequests() {
        
        guard let userID = defaults.getUID() else { return }
        
        outgoingRequests = defaults.getOutgoingRequests()
        
        // Check if the user has ongoing requests and update.
        let ongoingChatsRef = FIREBASE_REF.child("users").child(userID).child("chats")
        
        ongoingChatsRef.observe(.childAdded, with: { snapshot in
            
            if let postID = snapshot.value as? String {
                _ = self.outgoingRequests?.updateValue(true, forKey: postID)

                // find the cell to update and reload the indexpath.
                DispatchQueue.global().async {
                    for (index, post) in self.posts.enumerated() {
                        if post.postID == postID {
                            DispatchQueue.main.async {
                                self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                            }
                        }
                    }
                }
            }
            
        })
        
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
                
                //                
//                let hiddenPosts = defaults.getHiddenPosts()
//                if hiddenPosts.count == 0 || hiddenPosts[postID] == nil {
//                    print("post is not hidden")
//                    self.posts.insert(post, at: 0)
//
//                }

                
                
            }
            
            
        })
        
        postsRef.observeSingleEvent(of: .value, with: { snapshot in
            self.initialLoad = false
            self.tableView.reloadData()
        })
        /*
        postsRef.observe(.childChanged, with: { snapshot in
            
            let uidToChange = snapshot.key
            
            if let postData = snapshot.value as? Dictionary<String, AnyObject> {
                
                for (index, post) in self.posts.enumerated() {
                    if post.postID == uidToChange {
                        
                        if let post = Post(dictionary: postData) {
                            self.posts[index] = post
                            DispatchQueue.main.async(execute: {
                                UIView.performWithoutAnimation {
                                    self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                                }
                            })
                        }
                        
                    }
                }
            }
            
            
        })
        
        postsRef.observe(.childRemoved, with: { snapshot in
            
            let uidToRemove = snapshot.key

            for (index, post) in self.posts.enumerated() {
                if post.postID == uidToRemove {
                    self.posts.remove(at: index)
                        DispatchQueue.main.async(execute: {
                            self.tableView.beginUpdates()
                            self.tableView.deleteSections(IndexSet(integer: index), with: .automatic)
                            self.tableView.endUpdates()
                        })
                }
            }
            
            // remove on background thread since user isn't viewing this.
            DispatchQueue.global().async(execute: {
                
                for (index, post) in self.fullPosts.enumerated() {
                    if post.postID == uidToRemove {
                        self.fullPosts.remove(at: index)
                    }
                }
            })
            
        })
        */
        
        
        
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
                        "uid" : userID,
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

/*
extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Row: Int {
        case Profile
        case Post
        case Buttons
        case Relates
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check if 0 relates
        let post = posts[section]
        if post.getRelatesCount() < 1 {
            return 3
        }
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! FooterView
            return footerView
        default:
            assert(false, "Unexpected element kind")

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let post = posts[indexPath.section]
        
        switch row {
            
        case .Profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCell", for: indexPath) as! PostProfileCell
            
            cell.profileImage.image = nil
            
//            cell.nameLabel.text = post.name ?? "Anonymous"
            
            // Only load profile if the post is public
            if let username = post.getPostUsername() {
                cell.profileImage.loadProfileImage(post.getUserID())
                cell.usernameLabel.text = "@" + username
            }
            else {
                cell.profileImage.backgroundColor = Color.lightGray
                cell.usernameLabel.text = "Anonymous"
            }
            
            cell.postDelegate = self
            return cell
            
        case .Post:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTextCell", for: indexPath) as! PostTextCell
            cell.postLabel.text = post.text!
            return cell
            
        case .Buttons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostButtonsCell", for: indexPath) as! PostButtonsCell
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
            
        case .Relates:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTagsCell", for: indexPath) as! PostTagsCell
            cell.relatesCount = post.getRelatesCount()
            return cell
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let row = Row(rawValue: indexPath.row) else { return true }
        
        switch row {
        case .Profile:
            // if post.isanonymous = false
            let post = posts[indexPath.section]
            if post.name == "Anonymous" {
                return false
            }
            else {
                return true
            }
        case .Post:
            // double tap action
            return false
        case .Buttons:
            return false
        case .Relates:
            return true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        let post = posts[indexPath.section]
        switch row {
        case .Profile:
            
            if !post.isAnonymous {
                showProfile(section: indexPath.section)
            }
            
        case .Relates:
            let vc = RelatersViewController(postID: post.getPostID())
            masterViewDelegate?.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        guard let row = Row(rawValue: indexPath.row) else { return false }
        
        switch row {
        case .Buttons:
            return false
        default:
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cell = collectionView.cellForItem(at: indexPath)
//        let height = cell!.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        guard let row = Row(rawValue: indexPath.row) else { return CGSize() }
        
        switch row {
        case .Profile:
            return CGSize(width: collectionView.frame.width, height: 70)
        case .Post:
            
            let post = posts[indexPath.section]
                
            //let's get an estimation of the height of our cell based on user.bioText
            
            let approximateWidthOfTextView = collectionView.frame.width - 24
            let size = CGSize(width: approximateWidthOfTextView, height: 1000)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            
            let estimatedFrame = NSString(string: post.text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 114)

            
//            return CGSize(width: collectionView.frame.width, height: 100)
        case .Buttons:
            return CGSize(width: collectionView.frame.width, height: 44)
        case .Relates:
            return CGSize(width: collectionView.frame.width, height: 44)
            
        }
        
    }

}
*/
extension HomePage: UIGestureRecognizerDelegate {
    
}

extension HomePage: UITableViewDelegate, UITableViewDataSource {
    
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
