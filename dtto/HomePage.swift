//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol PostProtocol : class {
    func requestChat(section: Int, chatState: ChatState)
    func relatePost(row: Int)
    func showMore(cell: PostProfileCell, sender: AnyObject)
}

class HomePage: BaseCollectionViewCell, PostProtocol {
    
    var posts = [Post]()
    var fullPosts = [Post]()
    var outgoingRequests = [String : Bool]()
    
    var collectionView: UICollectionView!
    
    override func setupViews() {
        super.setupViews()
        
        observePosts()
        checkOutgoingRequests()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = Color.gray247
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(PostProfileCell.self, forCellWithReuseIdentifier: "PostProfileCell")
        collectionView.register(PostTextCell.self, forCellWithReuseIdentifier: "PostTextCell")
        collectionView.register(PostButtonsCell.self, forCellWithReuseIdentifier: "PostButtonsCell")
        collectionView.register(PostTagsCell.self, forCellWithReuseIdentifier: "PostTagsCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        collectionView.addGestureRecognizer(tap)
        
    }
    
    private func checkOutgoingRequests() {
        
        guard let userID = defaults.getUID() else { return }
        
        outgoingRequests = defaults.getOutgoingRequests()
        
        // Check if the user has ongoing requests and update.
        let ongoingChatsRef = FIREBASE_REF.child("users").child(userID).child("chats")
        ongoingChatsRef.observe(.childAdded, with: { snapshot in
            
            if let postID = snapshot.value as? String {
                self.outgoingRequests.updateValue(true, forKey: postID)

                // find the cell to update and reload the indexpath.
                DispatchQueue.global().async { [unowned self] in
                    for (index, post) in self.posts.enumerated() {
                        if post.postID == postID {
                            DispatchQueue.main.async {
                                self.collectionView.reloadSections(IndexSet(integer: index))
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

                let post = Post(dictionary: postData)
                
                //                
//                let hiddenPosts = defaults.getHiddenPosts()
//                if hiddenPosts.count == 0 || hiddenPosts[postID] == nil {
//                    print("post is not hidden")
//                    self.posts.insert(post, at: 0)
//
//                }
                self.posts.insert(post, at: 0)
                self.fullPosts.insert(post, at: 0)
                self.collectionView.reloadData()
                
            }
            
            
        })
        
        
        postsRef.observe(.childChanged, with: { snapshot in
            
            let uidToChange = snapshot.key
            
            if let postData = snapshot.value as? Dictionary<String, AnyObject> {
                
                for (index, post) in self.posts.enumerated() {
                    if post.postID == uidToChange {
                        self.posts[index] = Post(dictionary: postData)
                        DispatchQueue.main.async(execute: { [unowned self] in
                            self.collectionView.reloadSections(IndexSet(integer: index))
                        })
                    }
                }
            }
            
            
        })
        
        postsRef.observe(.childRemoved, with: { snapshot in
            
            let uidToRemove = snapshot.key

            for (index, post) in self.posts.enumerated() {
                if post.postID == uidToRemove {
                    self.posts.remove(at: index)
//                    DispatchQueue.main.async(execute: {
                    self.collectionView.deleteSections(IndexSet(integer: index))
//                    })
                }
            }
            
            // remove on background thread since user isn't viewing this.
            DispatchQueue.global().async(execute: { [unowned self] in
                
                for (index, post) in self.fullPosts.enumerated() {
                    if post.postID == uidToRemove {
                        self.fullPosts.remove(at: index)
                    }
                }
            })
            
        })
        
    }
    
    func requestChat(section: Int, chatState: ChatState) {
        
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 2, section: section)) as? PostButtonsCell else { return }
        
        let post = posts[section]
        guard let postID = post.postID, let friendID = post.userID, let userID = defaults.getUID() else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let chatRequestRef = FIREBASE_REF.child("requests").child(friendID).child(postID).child(userID)
        
        
        switch chatState {
            
        case .normal:

            cell.chatState = .requested
            chatRequestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                // if poster ignored this user, do nothing on server.
                if !snapshot.exists() {
                    
                    dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(friendID)/requestsCount"))

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
                        dataRequest.decrementCount(ref: FIREBASE_REF.child("users/\(friendID)/requestsCount"))
                        chatRequestRef.removeValue()

                    }
                }
                else {
                    
                }

                
            })

        case .ongoing:
            print("Already in chat, doing nothing...")
            break
        }
    
    }
    
    func relatePost(row: Int) {
        
        let post = posts[row]
        guard let postID = post.postID, let friendID = post.userID, let userID = defaults.getUID() else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let userRelatesRef = FIREBASE_REF.child("users/\(userID)/relatedPosts").child(postID)
        userRelatesRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                userRelatesRef.removeValue()
                dataRequest.decrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
            }
            else {
                userRelatesRef.setValue(true)
                dataRequest.incrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
            }
        })
        
    }
    
    func showMore(cell: PostProfileCell, sender: AnyObject) {
        
        guard let button = sender as? UIView, let section = collectionView.indexPath(for: cell)?.section else { return }
        
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy

        let post = posts[section]
        
        if let userID = defaults.getUID(), let postUID = post.userID {
            
            if userID == postUID {
                
                let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action:UIAlertAction) in
                    
                    self.deletePost(section: section)
                    
                })
                
                ac.addAction(delete)
                
                let edit = UIAlertAction(title: "Edit", style: .default, handler: { (action:UIAlertAction) in
                    
                    self.editPost(section: section)
                    
                })
                
                ac.addAction(edit)

            }
        }
        let hide = UIAlertAction(title: "Hide", style: .default, handler: { (action:UIAlertAction) in
            
            self.hidePost(section: section, postID: post.postID)
            
        })
        ac.addAction(hide)
        
        let report = UIAlertAction(title: "Report", style: .destructive, handler: { (action:UIAlertAction) in
            
            self.reportPost(postID: post.postID)
            
        })
        ac.addAction(report)
        
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
        guard let userID = defaults.getUID(), let postUID = post.userID, let postID = post.postID else { return }
        if postUID == userID {
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
            self.collectionView.performBatchUpdates({
                self.posts.remove(at: section)
                self.collectionView.deleteSections(IndexSet(integer: section))
            }, completion: nil)
            
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
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            guard let _ = self.collectionView.cellForItem(at: index) as? PostTextCell else { return }
            guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 2, section: index.section)) as? PostButtonsCell else { return }
            // request chat to this user
            cell.requestChat(cell.chatButton)
//            requestChat(row: index.row, chatState: cell.chatState)
        
        } else {
            print("Could not find index path")
        }
    }
    
    func showProfile(section: Int) {
        
        let post = posts[section]
        let profileVC = ProfileViewController(userID: post.userID!)
        
        masterViewDelegate?.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}

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
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let post = posts[indexPath.section]
        
        switch row {
            
        case .Profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCell", for: indexPath) as! PostProfileCell
            cell.nameLabel.text = post.name ?? "Anonymous"
            if let _ = post.username {
                cell.usernameLabel.text = "@" + post.username!
            }
            else {
                cell.usernameLabel.text = ""
            }
            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            cell.postDelegate = self
            return cell
            
        case .Post:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTextCell", for: indexPath) as! PostTextCell
            cell.postLabel.text = post.text!
            return cell
            
        case .Buttons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostButtonsCell", for: indexPath) as! PostButtonsCell
            cell.requestChatDelegate = self
            if let ongoing = outgoingRequests[post.postID!] {
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
            return cell
            
        case .Relates:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTagsCell", for: indexPath) as! PostTagsCell
            cell.relatesCount = post.relatesCount!
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
        
        switch row {
        case .Profile:
            let post = posts[indexPath.section]
            if !post.isAnonymous {
                showProfile(section: indexPath.section)
            }
            
        case .Relates:
            let vc = RelatersViewController()
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
            
            return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 14)

            
//            return CGSize(width: collectionView.frame.width, height: 100)
        case .Buttons:
            return CGSize(width: collectionView.frame.width, height: 44)
        case .Relates:
            return CGSize(width: collectionView.frame.width, height: 44)
            
        }
        
    }
    


}

extension HomePage: UIGestureRecognizerDelegate {
    
}
