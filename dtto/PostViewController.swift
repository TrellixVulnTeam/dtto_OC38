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
    
    var comments = [Comment]()
    
    lazy var commentInputContainerView: CommentInputContainerView = {
        let view = CommentInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.commentDelegate = self
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostProfileCell.self, forCellReuseIdentifier: "PostProfileCell")
        tableView.register(PostTextCell.self, forCellReuseIdentifier: "PostTextCell")
        tableView.register(PostButtonsCell.self, forCellReuseIdentifier: "PostButtonsCell")
        tableView.register(PostTagsCell.self, forCellReuseIdentifier: "PostTagsCell")
        tableView.register(CommentsTableView.self, forCellReuseIdentifier: "CommentsTableView")
        
        return tableView
    }()
    
    init(postID: String) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
        observePost()
        checkRelate()
        checkChat()
        observeComments()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
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
            
            guard let post = Post(snapshot: snapshot) else { return }
                
            DispatchQueue.main.async {
                self.post = post
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func checkRelate() {
        
        guard let userID = defaults.getUID() else { return }
        USERS_REF.child(userID).child("relatedPosts").child(postID).observe(.value, with: { snapshot in
            
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
        
        USERS_REF.child(userID).child("outgoingRequests").child(postID).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let requestDict = snapshot.value as? [String: String], let requestID = requestDict["requestID"], let posterID = requestDict["receiverID"] else { return }
            let requestRef = REQUESTS_REF.child(posterID).child(requestID)
            requestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                if let pending = snapshot.value as? Bool {
                    if pending {
                        self.chatState = .requested
                    }
                    else {
                        self.chatState = .ongoing
                    }
                }
            })
            
        })
        
    }
    
    
    func observeComments() {
        
        let postCommentsRef = COMMENTS_REF.child(postID)
        
        var initialLoad = true
        postCommentsRef.queryLimited(toLast: 2).observe(.childAdded, with: { snapshot in
            
            if let comment = Comment(snapshot: snapshot) {
                
                DispatchQueue.main.async {
                    self.comments.append(comment)
                    
                    if !initialLoad {
                        self.tableView.reloadData()
                    }
                }
            }
            
        })
        
        postCommentsRef.queryLimited(toLast: 2).observeSingleEvent(of: .value, with: { snapshot in
            
            initialLoad = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
        postCommentsRef.queryLimited(toLast: 2).observe(.childChanged, with: { snapshot in
            
            let commentID = snapshot.key
            
            DispatchQueue.main.async {
                for (index, comment) in self.comments.enumerated() {
                    if comment.getCommentID() == commentID {
                        
                        if let comment = Comment(snapshot: snapshot) {
                            self.comments[index] = comment
                            self.tableView.reloadData()
                        }
                        
                    }
                }
                
            }
            
        })
    }
    
    func postComment(textView: UITextView) {
        
        guard let post = post, let userID = defaults.getUID(), textView.text.characters.count > 0 else { return }
        
        let autoID = COMMENTS_REF.child(post.getPostID()).childByAutoId().key
        let postCommentsRef = COMMENTS_REF.child(post.getPostID()).child(autoID)
        
        let comment: [String:Any] = [
            "userID": userID,
            "username": "commentor1",
            "text" : textView.text,
            "timestamp" : [".sv" : "timestamp"]
        
        ]
        
        postCommentsRef.updateChildValues(comment)
        
        
        // increment the comment count for this post
        let dataRequest = FirebaseService.dataRequest
        dataRequest.incrementCount(ref: POSTS_REF.child(post.getPostID()).child("commentCount"))
        
        textView.text = ""
        textView.resignFirstResponder()
        
        // TODO: in functions, send notification

        
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case profile
        case post
        case buttons
        case relates
        case comments
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let post = post else { return 0 }
//        if post.getRelatesCount() < 1 {
//            return 4
//        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let row = Row(rawValue: indexPath.row), let post = post else { return 0 }
        
        switch row {
        case .relates:
            if post.getRelatesCount() == 0 {
                return 0
            }
        case .comments:
            if let profileCellHeight = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.frame.height, let textCellHeight = tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.frame.height, let buttonsCellHeight = tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.frame.height, let relatesHeight = tableView.cellForRow(at: IndexPath(row: 3, section: 0))?.frame.height {
                
//                print(tableView.frame.size.height - profileCellHeight - textCellHeight - buttonsCellHeight - relatesHeight)
                return tableView.frame.size.height - profileCellHeight - textCellHeight - buttonsCellHeight - relatesHeight - 50    // Post Textview height
            }

        default:
            break
        }
        
        return UITableViewAutomaticDimension
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
            
            cell.requestChatDelegate = self
            
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
            
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableView") as! CommentsTableView
            cell.comments = self.comments
            return cell
            
        }

    }
    
}

extension PostViewController: PostProtocol {
    
    func requestChat(cell: PostButtonsCell, chatState: ChatState) {
        
        guard let post = post else { return }
        
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
            let post = post,
            let userID = defaults.getUID(),
            let username = defaults.getUsername(),
            let name = defaults.getName() else { return }
        
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
                userRelatesRef.removeValue()
                dataRequest.decrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("relatesCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
                
                // remove this user from the post's list of related users
                postRelatesRef.removeValue()
                self.related = false
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
                self.related = true
            }
            
        })
        
    }
    
    func sharePost(cell: PostButtonsCell) {
        
        // create a URL
        guard let post = post else { return }
        
        let postID = post.getPostID()
        
        let vc = UIActivityViewController(activityItems: ["Help out a colleague. https://dtto.com/posts/\(postID)"], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    func showMore(cell: PostProfileCell, sender: AnyObject) {
        
    }
    

}
