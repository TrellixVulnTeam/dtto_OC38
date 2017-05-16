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

        var initialLoad = true
        
        let requestsRef = REQUESTS_REF.child(userID)
        
        requestsRef.observe(.childAdded, with: { snapshot in
            
            if let notification = UserNotification(snapshot: snapshot) {
                DispatchQueue.main.async {
                    self.requests.insert(notification, at: 0)
                    
                    if !initialLoad {
                        self.tableView.reloadData()
                        self.reloadView()
                    }
                }
            }
        
        })
        
        requestsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            initialLoad = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.reloadView()
            }
            
        })
        
        requestsRef.observe(.childRemoved, with: { snapshot in
            
            let removeRequestID = snapshot.key
            
            for (index, request) in self.requests.enumerated() {
                
                if request.getAutoID() == removeRequestID {
                    DispatchQueue.main.async {
                        self.requests.remove(at: index)
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.tableView.endUpdates()
                        self.reloadView()
                    }
                    
                }
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
    
    func handleRequest(row: Int, action: RequestAction) {
        
        let request = requests[row]
        
        guard let userID = defaults.getUID() else { return }
        let friendID = request.getSenderID()
        
        let dataRequest = FirebaseService.dataRequest
        
        switch action {
            
        case .accept:
            // check if user has subscription. Limit to 2 chats if they dont.
            // TODO: UI for showing 2 chats limit.
            
            print("accepted chat request!")
            
            // Create the chat room with these two users. This path will later be updated to show the last message of this chat room.
            
            let autoID = CHATS_REF.childByAutoId().key   // Update both userChats with this key.
            
            var chat: [String:Any] = ["posterID" : userID,
                                      "helperID" : friendID,
                                      "timestamp": FIREBASE_TIMESTAMP,
                                      "created" : FIREBASE_TIMESTAMP
                                      ]
            if let postID = request.getPostID() {
                chat.updateValue(postID, forKey: "postID")
            }
            CHATS_REF.child(autoID).updateChildValues(chat)
            
            // update chat list for both users
            dataRequest.startChat(userID: userID, chatID: autoID)
            dataRequest.startChat(userID: friendID, chatID: autoID)
            
            // increment number of ongoing chats for post.
            if let postID = request.getPostID() {
                dataRequest.incrementCount(ref: POSTS_REF.child(postID).child("ongoingChatCount"))
            }
            else {
                // TODO: Number of times a person received requests through search
            }

            // increment user's and friend's number of ongoing chats.
//            dataRequest.incrementCount(ref: USERS_REF.child(userID).child("ongoingChatCount"))
//            dataRequest.incrementCount(ref: USERS_REF.child(friendID).child("ongoingChatCount"))
            
            // increment user's and friend's number of total chats.
            dataRequest.incrementCount(ref: USERS_REF.child(userID).child("totalChatCount"))
            dataRequest.incrementCount(ref: USERS_REF.child(friendID).child("totalChatCount"))
            
            // Remove this request now.
            let requestRef = REQUESTS_REF.child(userID).child(request.getAutoID())
            requestRef.removeValue()

            
        case .decline:
            print("declined chat request!")
            
            // user ignored. To save data usage, remove the whole request except for the pending status (set to false) so that when the other user checks this request, user can't request again.

            let requestRef = REQUESTS_REF.child(userID).child(request.getAutoID())
            requestRef.setValue(["pending" : false])
//            requestRef.updateChildValues(["pending" : false,
//                                          "senderName" : nil,
//                                          "postID" : nil,
//                                          "timestamp" : nil,
//                                          "senderID" : nil
//                ])
//            
            break
        }
        
        // TODO: remove this request. also change the friend's outgoingRequest to ongoingChat. need to check if request was through post or search
//        let requestID = REQUESTS_REF.child(userID).child(request.getAutoID())
//        requestID.removeValue()
        dataRequest.decrementCount(ref: USERS_REF.child(userID).child("requestsCount"))
//
//        if let postID = request.getPostID() {
//            let friendOutgoingRequestsRef = FIREBASE_REF.child("outgoingRequests").child(friendID).child(postID)
//            friendOutgoingRequestsRef.removeValue()
//        }
        
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
        cell.usernameLabel.text = request.getSenderName()
        
        cell.requestsDelegate = self
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        
        return cell
        
    }
    
}
