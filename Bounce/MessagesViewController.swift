//
//  ChatViewController.swift
//  Bounce
//
//  Created by Jitae Kim on 11/23/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

final class MessagesViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
//    private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    var messagesRef: FIRDatabaseReference? {
        didSet {
            getMessages()
        }
    }
    
    private func setupNavBar() {
        let chatSettingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(showChatSettings))
        
        self.navigationItem.rightBarButtonItem = chatSettingsButton

    }
    
    private func setupCollectionView() {
        
        collectionView.collectionViewLayout = AnimatedFlowLayout()
        
    }
    func showChatSettings() {
        // push with nav bar.
        let chatSettings = ChatSettings(nibName: "ChatSettings", bundle: nil)
        navigationController?.pushViewController(chatSettings, animated: true)
    }
    
    private func getMessages() {
        
        guard let messagesRef = messagesRef else { return }
        messagesRef.observe(.childAdded, with: { snapshot in
            
            guard let messageData = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            if let senderID = messageData["senderID"] as? String, let name = messageData["name"] as? String, let text = messageData["text"] as? String {
                self.addMessage(withId: senderID, name: name, text: text)
                self.finishReceivingMessage()
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "uid1"
        self.senderDisplayName = "Jitae"
        hideKeyboardWhenTappedAround()
        setupNavBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: JSQMessages Delegate Methods
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        guard let messagesRef = messagesRef, let date = date else { return }
        
        let messageRef = messagesRef.childByAutoId()
        
        let messageItem = [
            "senderID": senderId!,
            "name": senderDisplayName!,
            "text": text!,
            "timestamp": "\(date)",
            ]
        
        messageRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage(animated: true)


        
    }

    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let a = JSQMessagesAvatarImage(placeholder: #imageLiteral(resourceName: "acceptNormal"))
        a?.avatarImage = #imageLiteral(resourceName: "profile")
        return a
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let timestamp = messages[indexPath.item].date
        
        let timeLabel = NSAttributedString(string: "\(timestamp)")
        return timeLabel
        
    }


    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }

}

class AnimatedFlowLayout: JSQMessagesCollectionViewFlowLayout {
    
}
