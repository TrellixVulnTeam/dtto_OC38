//
//  ChatViewController.swift
//  dtto
//
//  Created by Jitae Kim on 11/23/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import Photos
import DateTools

protocol PaymentConfirmationProtocol : class {
    func displayPaymentConfirmation()
}

final class MessagesViewController: JSQMessagesViewController, PaymentConfirmationProtocol {

    var chat: Chat
    var messagesRef: FIRDatabaseReference
    var chatsRef: FIRDatabaseReference
    var storageRef: FIRStorageReference
    var profileImage: UIImage?
    var friendID: String?
    
    var friendName: String? {
        didSet {
            title = friendName!
        }
    }
    var messages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private var newMessageRefHandle: FIRDatabaseHandle?

    init(chat: Chat) {
        self.chat = chat
        let chatID = chat.getChatID()
        messagesRef = FIREBASE_REF.child("messages").child(chatID)
        chatsRef = FIREBASE_REF.child("chats").child(chatID)
        storageRef = STORAGE_REF.child("messages").child(chatID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getFriendName()
        setupNavBar()
        setupChat()
        getMessages()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        collectionView.register(MessagesHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MessagesHeaderView")
//        collectionView.collectionViewLayout.headerReferenceSize = .init(width: SCREENWIDTH, height: 40)
//        collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
    
    private func setupNavBar() {
        
//        let resolveChatButton = UIBarButtonItem(image: #imageLiteral(resourceName: "check"), style: .plain, target: self, action: #selector(resolveChat))
//        let chatSettingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(showChatSettings))
        
        var buttons = [UIBarButtonItem]()
  
        let chatSettingsButton = UIButton(type: .system)
        chatSettingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        chatSettingsButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        chatSettingsButton.addTarget(self, action: #selector(chatSettings), for: .touchUpInside)
        buttons.append(UIBarButtonItem(customView: chatSettingsButton))
        
        guard let userID = defaults.getUID() else { return }
        
        if userID == chat.posterID {
            let resolveChatButton = UIButton(type: .system)
            resolveChatButton.setImage(#imageLiteral(resourceName: "resolveChat"), for: .normal)
            resolveChatButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            resolveChatButton.addTarget(self, action: #selector(resolveChat), for: .touchUpInside)
            buttons.append(UIBarButtonItem(customView: resolveChatButton))
        }
        navigationItem.rightBarButtonItems = buttons

    }
    
    func chatSettings() {
        
        if let friendID = friendID {
            let vc = ChatSettings(chat: chat, friendID: friendID)
            vc.chatRoomDelegate = self
            present(NavigationController(vc), animated: true, completion: nil)

        }
        else {
            print("Could not get friend info")
        }
    }
    
    func resolveChat() {
        
        guard let userID = defaults.getUID() else { return }
        let helperID = chat.getHelperID()
        
        let vc = ResolveChatViewController()
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
//        let checkoutVC = CheckoutViewController(helperID: "tw2QiARnU7ZFZ7we4tmKs3HcSU42", helperName: "Jitae")
//        checkoutVC.paymentConfirmationDelegate = self
//        
//        present(UINavigationController(rootViewController: checkoutVC), animated: true, completion: nil)
        
        // prompt user with screen that reviews that helper.
        // depending on the prompt, go to the payment selection screen. 
        
//        let resolveChatVC = ResolveChatViewController()
//        self.navigationController?.pushViewController(resolveChatVC, animated: true)
        
        
        let chatResolvedRef = CHATS_REF.child(chat.getChatID()).child("resolved")
        chatResolvedRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                
                // First time resolving chat.
                
                chatResolvedRef.setValue(true)
                
                let userRef = USERS_REF.child(userID)
                let helperRef = USERS_REF.child(helperID)
                
                let dataRequest = FirebaseService.dataRequest
                
                // Update this user's stats
                dataRequest.incrementCount(ref: userRef.child("helpsReceivedCount"))
                dataRequest.decrementCount(ref: userRef.child("ongoingChatCount"))
                
                // Update the helper's stats
                dataRequest.incrementCount(ref: helperRef.child("helpsGivenCount"))
                dataRequest.decrementCount(ref: helperRef.child("ongoingChatCount"))

            }
        })
        
    }
    
    private func getFriendName() {
        
        guard let userID = defaults.getUID() else { return }
        
        let postID = chat.getPostID()
        let helperID = chat.getHelperID()
        
        if userID == helperID {
            // Get the poster's name. Check if poster was anonymous
            let friendNameRef = FIREBASE_REF.child("posts").child(postID).child("name")
            friendNameRef.observeSingleEvent(of: .value, with: { snapshot in
                
                self.friendName = snapshot.value as? String ?? "Anonymous"
                
            })
        }
        else {
            // Get the helper's name.
            FIREBASE_REF.child("users").child(helperID).child("name").observeSingleEvent(of: .value, with: { snapshot in
                                
                self.friendName = snapshot.value as? String ?? "Anonymous"
            })
        }
    }
    
    private func getMessages() {
        
        let ref = FIREBASE_REF.child("messages").child(chat.getChatID())
        
        ref.observe(.childAdded, with: { snapshot in
            
            guard let messageData = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            if let senderID = messageData["senderID"] as? String, let name = messageData["name"] as? String, let text = messageData["text"] as? String, let timestamp = messageData["timestamp"] as? TimeInterval {
                
                let messageDate = Date(timeIntervalSince1970: timestamp/1000)
                
                self.addMessage(withId: senderID, name: name, text: text, date: messageDate)
                self.finishReceivingMessage()
            }
            
        })
    }
    
    func setupChat() {
        
        guard let userID = defaults.getUID() else { return }
        senderId = userID
        
        senderDisplayName = FIRAuth.auth()?.currentUser?.displayName ?? "Me"
        
        let posterID = chat.getPosterID()
        let helperID = chat.getHelperID()
        
        if userID == posterID {
            friendID = helperID
        }
        else {
            friendID = posterID
        }
        

    }
    
    func displayPaymentConfirmation() {
//        displayBanner(desc: "Payment Successful!")
        updateUserStats()
        
    }
    
    func updateUserStats() {
        
        let chatID = chat.getChatID()
        let chatRef = FIREBASE_REF.child("chats").child(chatID).child("resolved")
        chatRef.setValue(true)
        
        guard let userID = defaults.getUID(), let friendID = friendID else { return }
        
        let dataRequest = FirebaseService.dataRequest
        dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("helpsReceivedCount"))
        dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("tipsGivenCount"))
        dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("helpsGivenCount"))
        dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("tipsReceivedCount"))

    }
    
    // MARK: JSQMessages Delegate Methods
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        let messagesRef = FIREBASE_REF.child("messages").child(chat.getChatID())
        let messageItem: [String: Any] = [
            "senderID": senderId!,
            "name": senderDisplayName!,
            "text": text!,
            "timestamp": [".sv" : "timestamp"]
            ]
        
        messagesRef.childByAutoId().setValue(messageItem)
        
        // Also update the chat room's last message path.
        chatsRef.updateChildValues(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage(animated: true)

    }
    
    // MARK: Media Handling
    
    private let imageURLNotSetKey = "NOTSET"
    
    func sendPhotoMessage() -> String? {
        
        let itemRef = messagesRef.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": senderId!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        return itemRef.key
    }

    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messagesRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }

    private func addMessage(withId id: String, name: String, text: String, date: Date?) {

        if let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text) {
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
        
        // convert date
        var readableDate = NSAttributedString()
        
        if let messageDate = messages[indexPath.item].date {
            readableDate = NSAttributedString(string: messageDate.timeAgoSinceDate(numericDates: true))
        }
        
        return readableDate
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // TODO. Use actualy usernames and post keywords.
        let approximateWidthOfTextView = collectionView.frame.width - 20
        let size = CGSize(width: approximateWidthOfTextView, height: 500)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
        
        let estimatedFrame = NSString(string: "You are now connected with jae regarding your post about dtto").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: collectionView.frame.width, height: estimatedFrame.height + 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MessagesHeaderView", for: indexPath) as! MessagesHeaderView
        return headerView
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

// MARK: Image Picker Delegate
extension MessagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            
            // 3
            if let key = sendPhotoMessage() {
                // 4
                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    
                    // 5
                    let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    
                    // 6
                    self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                    }
                })
            }
        } else {
            // Handle picking a Photo from the Camera - TODO
            // 1
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            // 2
            if let key = sendPhotoMessage() {
                // 3
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                // 4
                let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                // 5
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                // 6
                storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading photo: \(error)")
                        return
                    }
                    // 7
                    self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}
