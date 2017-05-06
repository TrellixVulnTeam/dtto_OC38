//
//  AskPost.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ComposePostViewController: UIViewController {

    var post: Post?

    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeView(_:)))
        button.tintColor = Color.darkNavy
        return button
    }()
    
    lazy var postButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(post(_:)))
        button.tintColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    lazy var postToolbar: PostToolbar = {
        let postToolbar = PostToolbar(isPublic: false)
        postToolbar.composePostViewController = self
        return postToolbar
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return postToolbar
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 50
//        tv.separatorInset = .zero
//        tv.layoutMargins = .zero
        tv.separatorStyle = .none
        
        tv.register(PostNameCell.self, forCellReuseIdentifier: "PostNameCell")
        tv.register(PostComposeCell.self, forCellReuseIdentifier: "PostComposeCell")
        tv.register(PostAnonymousCell.self, forCellReuseIdentifier: "PostAnonymousCell")
        return tv
    }()

    // Either init as a clean new post, or edit a post
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        setupPost()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PostComposeCell {
            _ = textCell.postTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
        postToolbar.alpha = 0
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = postButton
        title = "Post"
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupPost() {
        
        postToolbar = PostToolbar(isPublic: false)
        postToolbar.composePostViewController = self
        
        if let _ = post?.name {
            postToolbar.enablePublic(enable: true)
        }
        else {
            postToolbar.enablePublic(enable: false)
        }
    }

    func closeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func post(_ sender: UIButton) {

        // Edit the post if this was inited with a postID
        if let post = post {
            editPost(post)
        }
        else {
            let postRef = FIREBASE_REF.child("posts")
            
            if let text = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PostComposeCell)?.postTextView.text, let userID = defaults.getUID() {
                
                let postID = postRef.childByAutoId().key
                // TODO: at timestamp
                var post: [String : Any] = ["postID": postID,
                                                "userID" : userID,
                                                "text" : text,
                                                "relatesCount" : 0,
                                                "ongoingChatCount" : 0,
                                                "commentCount" : 0
                                                ]
                

                // Add user's names if post is public
                if !postToolbar.anonymousToggle.isOn {
                    
                    if let name = defaults.getName(), let username = defaults.getUsername() {
                        post.updateValue(name, forKey: "name")
                        post.updateValue(username, forKey: "username")
                    }
                    
                }
                
                postRef.child(postID).updateChildValues(post)

                // Update user stats
                let userRef = FIREBASE_REF.child("users").child(userID)
                let dataRequest = FirebaseService.dataRequest
                dataRequest.incrementCount(ref: userRef.child("postCount"))
                
            }
                
            else {
                print("Could not post")
                // show some error
            }
            
            dismiss(animated: true, completion: nil)

        }
        
        
    }
    
    func editPost(_ post: Post) {
        
        let postID = post.getPostID()
        
        let postRef = FIREBASE_REF.child("posts").child(postID)
        
        if let text = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PostComposeCell)?.postTextView.text {
            
            // TODO: at timestamp
            let editedPost: [String : Any] = ["text" : text, "timestamp" : "editedTime"]
            
            postRef.updateChildValues(editedPost)
            
            // Update publicity
            if let _ = post.name, let _ = post.username {
                if postToolbar.anonymousToggle.isOn {
                    // change public to anonymous
                    postRef.child("name").removeValue()
                    postRef.child("username").removeValue()
                }
            }
            else {
                if !postToolbar.anonymousToggle.isOn {
                    // change anonymous to public
                    guard let name = defaults.getName(), let username = defaults.getUsername() else { return }
                    
                    let publicPost: [String : Any] = ["name" : name,
                                                      "username" : username]
                    postRef.updateChildValues(publicPost)
                }
            }
            
        }
            
        else {
            print("Could not post")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert() {
        let ac = UIAlertController(title: nil, message: "Please write your post.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { action in
            ac.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(confirmAction)

        self.present(ac, animated: true, completion: {
            ac.view.tintColor = Color.darkNavy
        })
    }
    
    func toggle(_ sender: UISwitch) {
        
        if let _ = post {
            enablePostButton(true)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            
            if sender.isOn {
                self.postToolbar.enablePublic(enable: true)
            }
            else {
                self.postToolbar.enablePublic(enable: false)
            }
        })
        
    }
    
    func enablePostButton(_ enabled: Bool) {
        
        if enabled {
            postButton.tintColor = Color.darkNavy
            postButton.isEnabled = true
        }
        else {
            postButton.tintColor = .lightGray
            postButton.isEnabled = false
        }
        
    }
    
}

extension ComposePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case Profile
        case Text
        case Anonymous
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        
        switch row {
        case .Profile:
            return 70
        case .Text:
            return tableView.frame.height - 120
        case .Anonymous:
            return 70
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostNameCell") as! PostNameCell
//            cell.selectionStyle = .none
            return cell
        case .Text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostComposeCell") as! PostComposeCell
            if let text = post?.text {
                cell.postTextView.text = text
            }
            cell.postTextView.delegate = self
            cell.selectionStyle = .none
            return cell
        case .Anonymous:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostAnonymousCell") as! PostAnonymousCell
            cell.selectionStyle = .none
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        switch row {
        case .Profile:
            guard let cell = tableView.cellForRow(at: indexPath) as? PostNameCell else { return }
            cell.keywordTextField.becomeFirstResponder()
        default:
            break
        }
        
    }
}

extension ComposePostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What's on your mind?" {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What's on your mind?"
            textView.textColor = Color.textGray
        }
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        postToolbar.characterCountLabel.text = String(200 - newText.characters.count)
        
        if newText.characters.count > 200 {
            postToolbar.characterCountLabel.textColor = .red
            return false
        }
        else {
            postToolbar.characterCountLabel.textColor = .lightGray
        }

        if (newText.characters.count < 1 || newText.characters.count > 200) {
            enablePostButton(false)
        }
        else {
            enablePostButton(true)
        }

        return true
    }
    
}
