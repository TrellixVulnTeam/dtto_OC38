//
//  CommentsTableViewTableViewCell.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class CommentsTableView: UITableViewCell {

    var postID: String?
    var comments = [Comment]() {
        didSet {
            tableView.reloadData()
            setupFooterView()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        
        return tableView
    }()

    lazy var viewAllCommentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("View All Comments", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(viewAllComments), for: .touchUpInside)
        return button

    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        addSubview(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupFooterView() {
        
        let footerView = UIView()
        footerView.addSubview(viewAllCommentsButton)
        
        viewAllCommentsButton.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, trailing: nil, bottom: footerView.bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 10, widthConstant: 0, heightConstant: 50)
        
        tableView.tableFooterView = footerView
    }

    func viewAllComments() {
        
    }

}

extension CommentsTableView: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.usernameLabel.text = comment.getUsername()
        cell.timestampLabel.text = comment.getTimeStamp().timeAgoSinceDate(numericDates: true)
        cell.commentLabel.text = comment.getText()
        
        if let _ = comments[indexPath.section].getReplies() {
            cell.hasReplies = true
        }
        else {
            cell.hasReplies = false
        }
        
        return cell
        
    }

    
}
