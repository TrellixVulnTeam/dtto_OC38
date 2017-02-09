//
//  ChatSettings.swift
//  dtto
//
//  Created by Jitae Kim on 12/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class ChatSettings: UIViewController {

    let chat: Chat
    let friendID: String
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
//        tv.backgroundColor = .white
        tv.estimatedRowHeight = 50
        tv.estimatedSectionHeaderHeight = 20
        tv.separatorStyle = .none
        tv.register(ProfileImageCell.self, forCellReuseIdentifier: "ProfileImageCell")
        
        return tv
    }()
    
    lazy var deleteChatButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(confirmDeleteAlert))
        button.tintColor = Color.darkNavy
        return button
    }()
    
    init(chat: Chat, friendID: String) {
        self.chat = chat
        self.friendID = friendID
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

    func setupViews() {
        
        title = "Chat Settings"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupNavBar() {
        
        self.navigationItem.rightBarButtonItem = deleteChatButton
        
    }
    
    func confirmDeleteAlert() {
        
        let ac = UIAlertController(title: "Remove Chat", message: "Remove this chat and all messages?", preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { action in
            self.deleteChat()
        })
        
        ac.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            ac.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(cancelAction)
        
        self.present(ac, animated: true, completion: {
            ac.view.tintColor = Color.darkNavy
        })

    }
    
    func deleteChat() {
        
        // present alert.
        
        guard let userID = defaults.getUID(), let chatID = chat.chatID else { return }
        
        // remove from user's chat list
        let userChatsRef = FIREBASE_REF.child("users").child(userID).child("chats").child(chatID)
        userChatsRef.removeValue()
        
        // update chat room, indicating that this user has deleted. If both users delete, then delete the chat room.
        let chatRef = FIREBASE_REF.child("chats").child(chatID)
        chatRef.child("deleted").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                // other user already deleted
                chatRef.removeValue()
            }
            else {
                chatRef.child("deleted").setValue(true)
            }
        })
        
    }
}

extension ChatSettings: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        
        case Profile

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            cell.profileImage.loadProfileImage(friendID)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Profile:
            let profileVC = ProfileViewController(userID: friendID)
            navigationController?.pushViewController(profileVC, animated: true)
        }
 
    }
}
