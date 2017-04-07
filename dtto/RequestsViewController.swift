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

    weak var masterViewDelegate: MasterCollectionView?
    var requests = [UserNotification]()
    var initialLoad = true

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 70
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.alpha = 0
        
        tableView.register(RequestsViewCell.self, forCellReuseIdentifier: "RequestsViewCell")

        return tableView
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.textGray
        label.textAlignment = .center
        label.text = "You have no more chat requests."
        label.alpha = 0
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(requests: [UserNotification]) {
        super.init(nibName: nil, bundle: nil)
        self.requests = requests
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
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        view.addSubview(tipLabel)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        tipLabel.anchorCenterSuperview()
        
        
    }
    
    private func observeRequests() {

        guard let userID = defaults.getUID() else { return }

        let requestsRef = REQUESTS_REF.child(userID)
        
        requestsRef.observe(.childAdded, with: { postID in

            let postID = postID.key
            
            requestsRef.child(postID).observe(.childAdded, with: { snapshot in
                
                if let userNotifications = snapshot.value as? Dictionary<String, AnyObject> {
                    
                    if let uid = userNotifications["senderID"] as? String, let name = userNotifications["name"] as? String,  let timestamp = userNotifications["timestamp"] as? String {
                        
                        let notification = UserNotification()
                        
                        notification.postID = postID
                        notification.name = name
                        notification.userID = uid
                        // process timestamp
                        notification.timestamp = timestamp
                        
                        self.requests.insert(notification, at: 0)
                        self.tableView.reloadData()
                        self.reloadView()
//                        self.tableView.beginUpdates()
//                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
//                        self.tableView.endUpdates()
                        
                    }

                }
                
            })
            
            requestsRef.child(postID).observe(.childRemoved, with: { snapshot in
                
                let removeRequestID = snapshot.key
                
                for (index, request) in self.requests.enumerated() {
                    
                    if let requestPostID = request.postID, let requestUserID = request.userID {
                        if requestPostID == postID && requestUserID == removeRequestID {
                            self.requests.remove(at: index)
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableView.beginUpdates()
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.endUpdates()
                            self.reloadView()
                        }
                    }
                }
                
            })

        })
        
        requestsRef.observe(.value, with: { snapshot in
            
            if !snapshot.exists() {
                self.reloadView()
            }
        })
        
    }
    
    func reloadView() {
        
        if requests.count == 0 {
            tableView.fadeOut()
            tipLabel.fadeIn()
        }
        else if tableView.alpha == 0 {
            tipLabel.fadeOut()
            tableView.fadeIn()
        }
    }

    
    func chatToDictionary(chat: Chat) -> [String : String]? {
        
        var chatDictionary = [String : String]()
        
        guard let name = chat.name, let uid = chat.senderID else {
            print("User dictionary is nil. something went wrong")
            return nil
        }
        let postID = chat.postID
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
        
        guard let userID = defaults.getUID(), let friendID = request.userID, let friendName = request.name, let postID = request.postID else { return }
        
        let userName = FIRAuth.auth()?.currentUser?.displayName ?? "Anonymous"
        
        let dataRequest = FirebaseService.dataRequest
        
        switch action {
            
        case .accept:
            
            print("accepted chat request!")
            
            // Create the chat room with these two users. This path will later be updated to show the last message of this chat room.
            
            let chatsRef = FIREBASE_REF.child("chats")
            let autoID = chatsRef.childByAutoId().key   // Update both userChats with this key.
            
            chatsRef.child(autoID).updateChildValues(["posterID" : userID, "helperID" : friendID, "postID" : postID])
//            let users = [userID : userName, friendID : friendName]
//            let baseChat: [String : Any] = ["users" : users, "postID" : postID]
//            chatsRef.updateChildValues([autoID : baseChat])
    
            // update chat list for both users, with the chat ID
            dataRequest.startChat(ref: FIREBASE_REF.child("users").child(userID).child("chats").child(autoID), postID: postID)
            dataRequest.startChat(ref: FIREBASE_REF.child("users").child(friendID).child("chats").child(autoID), postID: postID)
        
            // increment number of ongoing chats for post.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("posts").child(postID).child("chatCount"))
            
            // increment user's and friend's number of ongoing chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("ongoingChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("ongoingChatCount"))
            
            // increment user's and friend's number of total chats.
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("totalChatCount"))
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("totalChatCount"))

            
        case .decline:
            print("declined chat request!")


            break
        }
        
        // remove this request. also change the friend's outgoingRequest to ongoingChat
        let requestID = FIREBASE_REF.child("requests").child(userID).child(postID).child(friendID)
        requestID.removeValue()
        dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("requestsCount"))
        
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
        print(requests.count)
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsViewCell") as! RequestsViewCell
        
        let request = requests[indexPath.row]
        
        cell.profileImageView.image = #imageLiteral(resourceName: "profile")
        cell.usernameLabel.text = request.name
        
        cell.requestsDelegate = self
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        
        return cell
        
    }
    
}
