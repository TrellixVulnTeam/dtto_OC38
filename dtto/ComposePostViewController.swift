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

    var post = Post()
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }()
    
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
        let postToolbar = PostToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
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
    
    func closeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
//        self.navigationController!.dismiss(animated: true, completion: nil)
//        navigationController!.popToRootViewController(animated: true)
//        navigationController?.removeFromParentViewController()
        
    }
    
    func post(_ sender: UIButton) {
        
        let postRef = FIREBASE_REF.child("posts")
        
        if let text = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PostComposeCell)?.postTextView.text, let uid = FIRAuth.auth()?.currentUser?.uid {
            
            let postID = postRef.childByAutoId().key
            // TODO: at timestamp
            let basePost: [String : Any] = ["postID": postID,
                                                 "uid" : uid,
                                                 "text" : text,
                                                 "relatesCount" : 0,
                                                 "ongoingChatCount" : 0]
            
            postRef.child(postID).updateChildValues(basePost)
            defaults.setName(value: "Jitae")
            defaults.setUsername(value: "jitae")
            // Add user's names if post is public
            if postToolbar.publicToggle.isOn {
                
                guard let name = defaults.getName(), let username = defaults.getUsername() else { return }
                
                let publicPost: [String : Any] = ["name" : name,
                                                  "username" : username]
                postRef.child(postID).updateChildValues(publicPost)
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
        
        UIView.animate(withDuration: 0.2, animations: {
            
            if sender.isOn {
                self.postToolbar.privacyLabel.text = "Posting Publicly"
                self.postToolbar.privacyLabel.textColor = Color.darkNavy
                self.postToolbar.backgroundColor = .white
                print("switch is now on")
            }
            else {
                self.postToolbar.privacyLabel.text = "Posting Anonymously"
                self.postToolbar.privacyLabel.textColor = .lightGray
                self.postToolbar.backgroundColor = Color.darkNavy
                print("switch is now off")
            }
        })
        
    }

    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = postButton
        self.title = "Post"
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white

        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        hideKeyboardWhenTappedAround()
        setupKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let textCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PostComposeCell {
            _ = textCell.postTextView.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        dismissKeyboard()
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func handleKeyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
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
            cell.selectionStyle = .none
            return cell
        case .Text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostComposeCell") as! PostComposeCell
            cell.postTextView.delegate = self
//            _ = cell.postTextView.becomeFirstResponder()
            cell.selectionStyle = .none
            return cell
        case .Anonymous:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostAnonymousCell") as! PostAnonymousCell
            cell.selectionStyle = .none
            return cell

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
        }
        else {
            postToolbar.characterCountLabel.textColor = .lightGray
        }
        
        if newText.characters.count < 1 || newText.characters.count > 200 {
            postButton.tintColor = .lightGray
            postButton.isEnabled = false
        }
        else {
            postButton.tintColor = Color.darkNavy
            postButton.isEnabled = true
        }
        
        return true
    }
    
}
