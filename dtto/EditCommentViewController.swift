//
//  EditCommentViewController.swift
//  dtto
//
//  Created by Jitae Kim on 5/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EditCommentViewController: UIViewController, CommentProtocol {

    let comment: Comment
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    lazy var commentInputContainerView: CommentInputContainerView = {
        let view = CommentInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.commentDelegate = self
        view.textView.isUserInteractionEnabled = false
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
    
    init(_ comment: Comment) {
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = textView.becomeFirstResponder()
    }

    func setupViews() {
        
        title = "Edit Comment"
        view.backgroundColor = .white
        
        view.addSubview(textView)
        textView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupNavBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func postComment(textView: UITextView) {
        
        // editing comment. use the textview of this vc, and not the one inside the containerVIew.
        guard let userID = defaults.getUID(), self.textView.text.characters.count > 0 else { return }
        
        let commentRef = self.comment.getPostRef()
    
        let comment: [String:Any] = [
            "text" : self.textView.text,
            "timestamp" : [".sv" : "timestamp"],
            "edited" : true
        ]
        
        commentRef.updateChildValues(comment)
        
        self.textView.text = ""
        self.textView.resignFirstResponder()
        
        // dismiss
        dismiss(animated: true, completion: nil)
        
        // TODO: in functions, send notification
        
        
    }

}
