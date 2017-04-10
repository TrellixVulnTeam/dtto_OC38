//
//  ChatListViewController.swift
//  dtto
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ChatListViewController: BaseTableViewController {

    var chats = [Chat]()
    var requests = [UserNotification]()
    var requestsCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "ChatListCell")
        tableView.register(RequestsPreviewCell.self, forCellReuseIdentifier: "RequestsPreviewCell")
    }
    
    func observeChatRequestsCount() {
        
        guard let userID = defaults.getUID() else { return }
        let chatRequestsCountRef = FIREBASE_REF.child("users").child(userID).child("requestsCount")
        chatRequestsCountRef.observe(.value, with: { snapshot in
            
            self.requestsCount = snapshot.value as? Int ?? 0
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            
        })
        
    }
    
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case requests
        case chats
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .requests:
            return 1
        case .chats:
            return chats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .requests:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsPreviewCell") as! RequestsPreviewCell
            cell.requestsCount = requestsCount
            return cell
            
            
        case .chats:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
            cell.lastMessageLabel.text = chats[indexPath.row].lastMessage
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
            
        case .requests:
            let requestsView = RequestsViewController()
            //            let requestsView = RequestsViewController(requests: requests)
            navigationController?.pushViewController(requestsView, animated: true)
            
        case .chats:
            let chat = chats[indexPath.row]
            
            let messagesViewController = MessagesViewController(chat: chat)
            
            navigationController?.pushViewController(messagesViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard let section = Section(rawValue: indexPath.section) else { return false }
        switch section {
        case .requests:
            return false
        case .chats:
            return true
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
        })
        
        let mute = UITableViewRowAction(style: .destructive, title: "Mute", handler: { (action, indexPath) in
            
        })
        return [delete, mute]
    }
    
}

