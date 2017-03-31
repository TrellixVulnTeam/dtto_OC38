//
//  ChatList.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ChatList: BaseCollectionViewCell {

    var chats = [Chat]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var requests = [UserNotification]()
    var requestsCount = 0
    
    override func setupViews() {
        super.setupViews()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "ChatListCell")
        tableView.register(RequestsCell.self, forCellReuseIdentifier: "RequestsCell")
        
        observeChatRequestsCount()
        
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

extension ChatList: UITableViewDelegate, UITableViewDataSource {

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsCell") as! RequestsCell
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
            let requestsView = RequestsViewController(requests: requests)
            if let vd = masterViewDelegate {
                requestsView.masterViewDelegate? = vd
            }
            masterViewDelegate?.navigationController?.pushViewController(requestsView, animated: true)
            
        case .chats:
            let chat = chats[indexPath.row]
            
            let messagesViewController = MessagesViewController(chat: chat)
            
            masterViewDelegate?.navigationController?.pushViewController(messagesViewController, animated: true)
        }
    }
    
}

