//
//  RequestsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/22/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

enum RequestAction {
    case accept
    case decline
}

protocol RequestsDelegate : class {
    func handleRequest(row: Int, action: RequestAction)
}

class RequestsViewController: UIViewController, RequestsDelegate {

    var masterViewDelegate: MasterCollectionView? {
        didSet {
            print("Delegate")
        }
    }
    var requests = [UserNotification]()
//    var requestsRef: FIRDatabaseReference! = FIREBASE_REF.child("requests/uid1") {
//        didSet {
//            // get requests
//            getRequests()
//        }
//    }
    lazy var viewChatsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "chatSelected"), style: .plain, target: self, action: #selector(viewChats(_:)))
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 70
        tv.allowsSelection = false
        return tv
    }()
    
    init(requests: [UserNotification]) {
        super.init(nibName: nil, bundle: nil)
        self.requests = requests
        print(self.requests.count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeRequests()

    }
    
    private func setupViews() {
        
        navigationItem.title = "Chat Requests"
        navigationItem.rightBarButtonItem = viewChatsButton
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableView.register(RequestsViewCell.self, forCellReuseIdentifier: "RequestsViewCell")
        
    }
    

    private func observeRequests() {
        
        guard let userID = defaults.getUID() else { return }
        
        let requestsRef = FIREBASE_REF.child("requests/\(userID)")
        requestsRef.observe(.childAdded, with: { snapshot in
            
            guard let userNotifications = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            guard let uid = userNotifications["uid"] as? String, let notificationID = userNotifications["notificationID"] as? String, let name = userNotifications["name"] as? String, let postID = userNotifications["postID"] as? String, let timestamp = userNotifications["timestamp"] as? String else { return }
            
            let notification = UserNotification()
            
            notification.name = name
            notification.postID = postID
            notification.userID = uid
            notification.notificationID = notificationID
            // process timestamp
            notification.timestamp = timestamp
            if let profileImageURL = userNotifications["profileImageURL"] as? String {
                notification.profileImageURL = profileImageURL
            }
            
            self.requests.append(notification)
            self.tableView.reloadData()
        })
        
        requestsRef.observe(.childRemoved, with: { snapshot in
            
            let requestToRemove = snapshot.key
            
            for (index, request) in self.requests.enumerated() {
                if let notificationID = request.notificationID {
                    if requestToRemove == notificationID {
                        self.requests.remove(at: index)
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            
        })
        
    }

    
    func chatToDictionary(chat: Chat) -> [String : String]? {
        
        var chatDictionary = [String : String]()
        
        guard let name = chat.name, let uid = chat.senderID, let postID = chat.postID else {
            print("User dictionary is nil. something went wrong")
            return nil
        }
        
        chatDictionary.updateValue(name, forKey: "name")
        chatDictionary.updateValue(uid, forKey: "senderID")
        chatDictionary.updateValue(postID, forKey: "postID")
        
        if let profile = chat.profileImageURL {
            chatDictionary.updateValue(profile, forKey: "profileImageURL")
        }
        
        return chatDictionary
        
    }
    
    func handleRequest(row: Int, action: RequestAction) {
        
        let request = requests[row]
        
        guard let userID = defaults.getUID(), let friendID = request.userID, let friendName = request.name, let postID = request.postID, let requestID = request.notificationID else { return }
        
        let userName = FIRAuth.auth()?.currentUser?.displayName ?? "Anonymous"
        
        let dataRequest = FirebaseService.dataRequest
        
        switch action {
            
        case .accept:
            
            print("accepted chat request!")
            
            // Create the chat room with these two users. This path will later be updated to show the last message of this chat room.
            
            let chatsRef = FIREBASE_REF.child("chats")
            let autoID = chatsRef.childByAutoId().key   // Update both userChats with this key.
            let users = [userID : userName, friendID : friendName]
            let baseChat: [String : Any] = ["users" : users, "postID" : postID]
            chatsRef.updateChildValues([autoID : baseChat])


            
            // update chat list for both users, with the chat ID
            dataRequest.startChat(ref: FIREBASE_REF.child("users/\(userID)/chats/\(autoID)"))
            dataRequest.startChat(ref: FIREBASE_REF.child("users/\(friendID)/chats/\(autoID)"))
        
            // increment number of ongoing chats for post.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("posts/\(postID)/chatCount"))
            
            // increment user's and friend's number of ongoing chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/ongoingChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(friendID)/ongoingChatCount"))
            
            // increment user's and friend's number of total chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/totalChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(friendID)/totalChatCount"))

            
        case .decline:
            print("declined chat request!")


            break
        }
        
        // remove this request.
        dataRequest.removeRequest(requestID: requestID)
        dataRequest.decrementCount(ref: FIREBASE_REF.child("users/\(userID)/requestsCount"))

        
    }

    func viewChats(_ sender: UIBarButtonItem) {

        _ = self.masterViewDelegate?.navigationController?.popViewController(animated: true)

    }

}

extension RequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsViewCell") as! RequestsViewCell
        
        let request = requests[indexPath.row]
        
        cell.profileImage.image = #imageLiteral(resourceName: "profile")
        cell.nameLabel.text = "Jitae"
        cell.usernameLabel.text = "@jitae"
        
        cell.requestsDelegate = self
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        
        return cell
        
    }
    
}
