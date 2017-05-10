//
//  CommentsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 5/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, CommentProtocol {

    let post: Post
    var comments = [Comment]()
    var commentsDictionary = [String:Comment]()
    var commentsTotalCount = 0
    
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
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textGray
        label.textAlignment = .center
        label.text = "Be the first to comment!"
        label.alpha = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 100
        
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        
        return tableView
    }()
    
    lazy var viewMoreCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View More Comments", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(fetchMoreComments), for: .touchUpInside)
        return button
        
    }()
    
    init(post: Post) {
        self.post = post
        self.commentsTotalCount = post.getCommentCount()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        COMMENTS_REF.child(post.getPostID()).removeAllObservers()
        POSTS_REF.child(post.getPostID()).child("commentCount").removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeCommentsCount()
        observeComments()
        setupKeyboardObservers()
        setupTapGesture()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        becomeFirstResponder()
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func setupViews() {
        
        view.backgroundColor = .white
        title = "Comments"
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        view.addSubview(tipLabel)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tipLabel.anchorCenterSuperview()
        
    }
    
    func setupHeaderView() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.addSubview(viewMoreCommentsButton)
        
        viewMoreCommentsButton.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, trailing: nil, bottom: headerView.bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 50)
        tableView.tableHeaderView = headerView
    }
    
    func setupTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func dismissKeyboard() {
        _ = commentInputContainerView.textView.resignFirstResponder()
    }
    
    func observeCommentsCount() {
        
        let postCommentsCountRef = POSTS_REF.child(post.getPostID()).child("commentCount")
        postCommentsCountRef.observe(.value, with: { snapshot in
            
            guard let count = snapshot.value as? Int else { return }
            self.commentsTotalCount = count
            
        })
    }
    
    func observeComments() {
        
        let postCommentsRef = COMMENTS_REF.child(post.getPostID())
        
        var initialLoad = true
        postCommentsRef.queryLimited(toLast: 10).observe(.childAdded, with: { snapshot in
            
            if let comment = Comment(snapshot: snapshot) {
                
                DispatchQueue.main.async {
                    
                    if self.commentsDictionary[comment.getCommentID()] == nil {
                        self.commentsDictionary.updateValue(comment, forKey: comment.getCommentID())
                    }
                    
                    if !initialLoad {
                        self.attemptReloadOfChats()
                        
                        if self.commentsDictionary.count < self.commentsTotalCount {
                            self.setupHeaderView()
                        }
                        else {
                            self.tableView.tableHeaderView = nil
                        }
                    }
                }
            }
            
        })
        
        postCommentsRef.queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { snapshot in
            
            initialLoad = false
            DispatchQueue.main.async {
                if self.commentsDictionary.count < self.commentsTotalCount {
                    self.setupHeaderView()
                }
                self.attemptReloadOfChats()
            }
            
        })
        
        postCommentsRef.queryLimited(toLast: 10).observe(.childChanged, with: { snapshot in
            
            let commentID = snapshot.key

            if let comment = Comment(snapshot: snapshot) {
                self.commentsDictionary.updateValue(comment, forKey: comment.getCommentID())
                self.attemptReloadOfChats()
            }

            
        })
        
        postCommentsRef.queryLimited(toLast: 10).observe(.childRemoved, with: { snapshot in
            
            let commentID = snapshot.key
            
            self.commentsDictionary.removeValue(forKey: commentID)
            self.attemptReloadOfChats()
            
        })
        
    }
    
    func fetchMoreComments() {
        
        guard let lastCommentKey = comments.first?.getCommentID() else { return }
        print(lastCommentKey)
        if commentsDictionary.count < commentsTotalCount {
            let postCommentsRef = COMMENTS_REF.child(post.getPostID())
            
            postCommentsRef.queryOrderedByKey().queryEnding(atValue: lastCommentKey).queryLimited(toLast: 11).observe(.childAdded, with: { snapshot in
                
                if let comment = Comment(snapshot: snapshot) {
                    
                    DispatchQueue.main.async {
                        
                        // don't add duplicates
                        if self.commentsDictionary[comment.getCommentID()] == nil {
                            self.commentsDictionary.updateValue(comment, forKey: comment.getCommentID())
                            
                            if self.commentsDictionary.count < self.commentsTotalCount {
                                self.setupHeaderView()
                            }
                            else {
                                self.tableView.tableHeaderView = nil
                            }
                            self.attemptReloadOfChats()
                        }
                        
                    }
                }
                
            })
            
        }
    
    }
    
    func postComment(textView: UITextView) {
        
        guard let userID = defaults.getUID(), textView.text.characters.count > 0 else { return }
        
        let autoID = COMMENTS_REF.child(post.getPostID()).childByAutoId().key
        let postCommentsRef = COMMENTS_REF.child(post.getPostID()).child(autoID)
        
        let comment: [String:Any] = [
            "userID": userID,
            "username": "commenter1",
            "text" : textView.text,
            "timestamp" : [".sv" : "timestamp"]
        ]
        
        postCommentsRef.updateChildValues(comment)
        
        
        // increment the comment count for this post
        let dataRequest = FirebaseService.dataRequest
        dataRequest.incrementCount(ref: POSTS_REF.child(post.getPostID()).child("commentCount"))
        
        commentInputContainerView.resetTextView()
        
        // update user's comments. /comments/postID/commentID
        USERS_REF.child(userID).child("comments").child(post.getPostID()).child(autoID).setValue(true)
        
    }
    
    func viewProfile(cell: CommentCell) {
        
        guard let section = tableView.indexPath(for: cell)?.section else { return }
        let comment = comments[section]
        
        let userID = comment.getUserID()
        
        let vc = ProfileViewController(userID: userID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func handleKeyboardDidShow() {
        if comments.count > 0 {
            let indexPath = IndexPath(row: 0, section: comments.count - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }

    var timer: Timer?
    
    func attemptReloadOfChats() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloadComments), userInfo: nil, repeats: false)
    }
    
    func handleReloadComments() {
        
        DispatchQueue.main.async {

            if self.commentsDictionary.count > 0 {
                self.comments = Array(self.commentsDictionary.values)
            
                self.comments.sort(by: { (comment1, comment2) -> Bool in
                    return comment1.getTimestamp() < comment2.getTimestamp()
                })
                
                self.tipLabel.alpha = 0
                self.tableView.fadeIn()
                
            }
            else {
                self.tableView.alpha = 0
                self.tipLabel.fadeIn()
            }
        
            self.tableView.reloadData()
        }
    }
    
    func deleteComment(_ comment: Comment) {
        
        guard let userID = defaults.getUID() else { return }
        let alertController = UIAlertController(title: "Delete comment?", message: "", preferredStyle: .alert)
        alertController.view.tintColor = Color.darkNavy
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 10
        
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
//            FIRAnalytics.logEvent(withName: "ExportedArcana", parameters: [
//                "name": self.arcana.getNameKR() as NSObject,
//                "arcanaID": self.arcana.getUID() as NSObject
//                ])
            let commentRef = COMMENTS_REF.child(self.post.getPostID()).child(comment.getCommentID())
            commentRef.removeValue()
            
            if let postRef = comment.getCommentRef().parent?.key {
                let dataRequest = FirebaseService.dataRequest
                dataRequest.decrementCount(ref: POSTS_REF.child(postRef).child("commentCount"))
            }
            
            
            // delete at /user/comments/
            USERS_REF.child(userID).child("comments").child(self.post.getPostID()).child(comment.getCommentID()).removeValue()
            
            // TODO: Decrement user commentsCount and post commentsCount
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        present(alertController, animated: true) {
            alertController.view.tintColor = Color.darkNavy
        }

    }
    
    func editComment(_ comment: Comment) {
        
        let vc = EditCommentViewController(comment)
        present(NavigationController(vc), animated: true, completion: nil)
        
    }
    
    func reportComment(_ comment: Comment) {
        
        guard let userID = defaults.getUID() else { return }
        
        let alertController = UIAlertController(title: "Report this comment?", message: "", preferredStyle: .alert)
        alertController.view.tintColor = Color.darkNavy
        alertController.view.backgroundColor = .white
        alertController.view.layer.cornerRadius = 10
        
        let report = UIAlertAction(title: "Report", style: .destructive, handler: { action in
            
            FIRAnalytics.logEvent(withName: "ReportComment", parameters: [
                "userID": comment.getUserID() as NSObject,
                "reporterID": userID as NSObject
                ])
            let reportRef = REPORTS_REF.childByAutoId()
            
            let report: [String:Any] = [
                "userID" : comment.getUserID(),
                "text" : comment.getText(),
                "reporterID" : userID
            ]
            
            reportRef.updateChildValues(report)
            
            // TODO: Increment report count for the user?
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(report)
        alertController.addAction(cancel)
        
        present(alertController, animated: true) {
            alertController.view.tintColor = Color.darkNavy
        }
        
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let repliesCount = comments[section].getReplies()?.count {
            return repliesCount + 1
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.navigationDelegate = self
        cell.usernameLabel.text = comment.getUsername()
        cell.timestampLabel.text = comment.getTimestamp().timeAgoSinceDate(numericDates: true)
        if let editTimestamp = comment.getEditTimestamp() {
            cell.editTimestampLabel.text = "Edited \(editTimestamp.timeAgoSinceDate(numericDates: true))"
        }
        else {
            cell.editTimestampLabel.text = ""
        }
        cell.commentLabel.text = comment.getText()
        
        if let _ = comments[indexPath.section].getReplies() {
            cell.hasReplies = true
        }
        else {
            cell.hasReplies = false
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let comment = comments[indexPath.section]

        guard let userID = defaults.getUID() else { return }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy
        
        if comment.getUserID() == userID {
            // User's own post. edit or delete

            let edit = UIAlertAction(title: "Edit", style: .default, handler: { action in
                self.editComment(comment)
            })
            
            ac.addAction(edit)
            
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self.deleteComment(comment)
            })
            
            ac.addAction(delete)

        }
        else {
            // other user's comment. reply, report, block.
            let report = UIAlertAction(title: "Report", style: .destructive, handler: { action in
                self.reportComment(comment)
            })
            
            ac.addAction(report)

        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = ac.popoverPresentationController, let cell = tableView.cellForRow(at: indexPath) as? CommentCell {
            presenter.sourceView = cell
            presenter.sourceRect = cell.bounds
        }
        
        present(ac, animated: true, completion: { () -> () in
            ac.view.tintColor = Color.darkNavy
        })

    }
    
}
