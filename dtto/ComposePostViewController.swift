//
//  AskPost.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

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
        button.tintColor = Color.darkNavy
        return button
    }()

    
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
        
        let textCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PostComposeCell
        if textCell.postTextView.text.characters.count == 0 {
            // present alert
            showAlert()
        }
        
    }
    
    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = postButton
        self.title = "Post"
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
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
//        view.addSubview(headerView)
//        headerView.addSubview(closeButton)
//        headerView.addSubview(postButton)
        view.addSubview(tableView)
        
//        headerView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
//        
//        closeButton.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, trailing: nil, bottom: headerView.bottomAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
//        
//        postButton.anchor(top: headerView.topAnchor, leading: nil, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
        dismissKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }

}

extension ComposePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case Profile
        case Text
        case Anonymous
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
    
}
