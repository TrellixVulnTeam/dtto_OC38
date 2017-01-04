//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol QuestionProtocol : class {
    func requestChat(row: Int, chatState: ChatState)
    func relatePost(row: Int)
    func showMore(row: Int, sender: AnyObject)
}

class HomePage: BaseCollectionViewCell, QuestionProtocol {
    
    var posts = [Question]()
    var fullPosts = [Question]()
    
    var collectionView: UICollectionView!
    
    override func setupViews() {
        
        observeQuestions()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
//        layout.estimatedItemSize = CGSize(width: 50, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = Color.gray247
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.register(UINib(nibName: "NameCell", bundle: nil), forCellWithReuseIdentifier: "NameCell")
        collectionView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellWithReuseIdentifier: "QuestionCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        collectionView.addGestureRecognizer(tap)
        
    }
    
    private func observeQuestions() {
        
        let questionsRef = FIREBASE_REF.child("questions")
        
        questionsRef.observe(.childAdded, with: { snapshot in
            
            if let questionData = snapshot.value as? Dictionary<String, AnyObject> {
                
                guard let questionID = questionData["questionID"] as? String, let text = questionData["text"] as? String, let userID = questionData["uid"] as? String else { return }
                
                let question = Question()
                question.questionID = questionID
                question.text = text
                question.userID = userID
                
                let name = questionData["name"] as? String ?? "Anonymous"
                question.name = name
                
                if let chatCount = questionData["chatCount"] as? Int {
                    question.chatCount = chatCount
                }
                
                if let relateCount = questionData["relateCount"] as? Int {
                    question.relateCount = relateCount
                }
                
                if let tags = questionData["tags"] as? Dictionary<String, AnyObject> {
                    for tag in tags {
                        question.tags = "\(question.tags), \(tag.key)"
                    }
                }
                
                let hiddenPosts = defaults.getHiddenPosts()
                if hiddenPosts.count == 0 || hiddenPosts[questionID] == nil {
                    print("question is not hidden")
                    self.posts.insert(question, at: 0)

                }

                self.fullPosts.insert(question, at: 0)
                self.collectionView.reloadData()
                
            }
            
            
        })
    }
    
    func requestChat(row: Int, chatState: ChatState) {
        
        guard let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? QuestionCell else { return }
        
        let question = posts[row]
        guard let questionID = question.questionID, let friendID = question.userID, let userID = defaults.getUID() else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let chatRequestRef = FIREBASE_REF.child("requests").child(friendID).child(questionID).child(userID)
        
        switch chatState {
            
        case .normal:

            cell.chatState = .requested
            chatRequestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                // if poster ignored this user, do nothing on server.
                if !snapshot.exists() {
                    
                    dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/requestsCount"))

                    let request: [String: Any] = [
                        "name": "Jae",
                        "questionID" : questionID,
                        "timestamp" : "11-11",
                        "uid" : "uid2",
                        "pending" : true
                    ]
                    
                    chatRequestRef.setValue(request)
                }

            })
            
        case .requested:

            cell.chatState = .normal
            chatRequestRef.child("pending").observeSingleEvent(of: .value, with: { snapshot in
                
                // if poster has not ignored yet, cancel the request.
                if snapshot.value as! Bool == true {
                    
                    dataRequest.decrementCount(ref: FIREBASE_REF.child("users/\(userID)/requestsCount"))
                    chatRequestRef.removeValue()
                    
                }
                
            })

        case .ongoing:
            print("Already in chat, doing nothing...")
            break
        }
    
    }
    
    func relatePost(row: Int) {
        
        let question = posts[row]
        guard let questionID = question.questionID, let friendID = question.userID, let userID = defaults.getUID() else { return }
        
        let dataRequest = FirebaseService.dataRequest
        let userRelatesRef = FIREBASE_REF.child("users/\(userID)/relatedPosts").child(questionID)
        userRelatesRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                userRelatesRef.removeValue()
                dataRequest.decrementCount(ref: FIREBASE_REF.child("questions").child(questionID).child("relatesCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.decrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
            }
            else {
                userRelatesRef.setValue(true)
                dataRequest.incrementCount(ref: FIREBASE_REF.child("questions").child(questionID).child("relatesCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(friendID).child("relatesReceivedCount"))
                dataRequest.incrementCount(ref: FIREBASE_REF.child("users").child(userID).child("relatesGivenCount"))
            }
        })
        
    }
    
    func showMore(row: Int, sender: AnyObject) {
        
        guard let button = sender as? UIView else {
            return
        }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy

        let question = posts[row]
        
        let hide = UIAlertAction(title: "Hide", style: .default, handler: { (action:UIAlertAction) in
            
            self.hidePost(row: row, questionID: question.questionID)
            
            
        })
        ac.addAction(hide)
        
        let report = UIAlertAction(title: "Report", style: .destructive, handler: { (action:UIAlertAction) in
            
            
        })
        ac.addAction(report)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alertAction: UIAlertAction!) in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        if let presenter = ac.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        masterViewDelegate?.present(ac, animated: true, completion: { () -> () in
            ac.view.tintColor = Color.darkNavy
        })
        
    }
    
    func hidePost(row: Int, questionID: String?) {
        
        if let questionID = questionID {
            
            defaults.hidePost(postID: questionID)
            let index = IndexPath(row: row, section: 0)
            self.collectionView.performBatchUpdates({
                self.posts.remove(at: row)
                self.collectionView.deleteItems(at: [index])
            }, completion: nil)
            
        }
        
    }
    
    func doubleTapped(_ gestureReconizer: UITapGestureRecognizer) {
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            guard let cell = self.collectionView.cellForItem(at: index) as? QuestionCell else { return }
            cell.selectButton(cell.chatButton)
            // request chat to this user
            requestChat(row: index.row, chatState: cell.chatState)
        
        } else {
            print("Could not find index path")
        }
    }
    
    
}

extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Row: Int {
        
        case Name
        case Question
        case Buttons
        case Relates
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let _ = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let question = posts[indexPath.row]

//        switch row {
//        case .Name:
//        case .Question:
//        case .Buttons:
//        case .Relates:
//            
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.requestChatDelegate = self
        
        
        cell.moreButton.tag = indexPath.row
        cell.relateButton.tag = indexPath.row
        cell.chatButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        
        cell.relateButton.setImage(#imageLiteral(resourceName: "upvote"), for: .normal)
        cell.relateButton.setImage(#imageLiteral(resourceName: "upvote"), for: .selected)
        cell.chatButton.setImage(#imageLiteral(resourceName: "chatNormal"), for: .normal)
        cell.chatButton.setImage(#imageLiteral(resourceName: "chatSelected"), for: .selected)
        cell.chatButton.setTitle("Chat", for: .normal)
        cell.chatButton.setTitleColor(Color.textGray, for: .normal)
        cell.chatButton.setTitle("Chat Requested!", for: .selected)
        cell.chatButton.setTitleColor(Color.darkSalmon, for: .selected)
        cell.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        cell.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .selected)
        
        // check if user already requested chat.
        let outgoingRequests = defaults.getOutgoingRequests()
        print(outgoingRequests.count)
        if let _ = outgoingRequests[question.questionID!] {
            cell.chatButton.isSelected = true
        }
        else {
            cell.chatButton.isSelected = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cell = collectionView.cellForItem(at: indexPath)
//        let height = cell!.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    


}

extension HomePage: UIGestureRecognizerDelegate {
    
}
