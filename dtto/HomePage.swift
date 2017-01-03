//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol QuestionProtocol : class {
    func requestChat(row: Int)
    func showMore(row: Int, sender: AnyObject)
}

class HomePage: BaseCollectionViewCell, QuestionProtocol {
    
    var questions = [Question]()
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
                
                self.questions.append(question)
                self.collectionView.reloadData()
                
            }
            
            
        })
    }
    
    func requestChat(row: Int) {
        
        let question = questions[row]
        
        guard let questionID = question.questionID, let friendID = question.userID, let userID = defaults.getUID() else { return }
        
        // check if this questionID is one that the user already requested.
        var outgoingRequests = [String : String]()
        outgoingRequests = defaults.getOutgoingRequests()
        print(outgoingRequests.count)
        let dataRequest = FirebaseService.dataRequest
        
        if let value = outgoingRequests[questionID] {
            // cancel chat request
            print("Cancel chat request")
            dataRequest.decrementCount(ref: FIREBASE_REF.child("users/\(userID)/requestsCount"))
            outgoingRequests.removeValue(forKey: questionID)
            FIREBASE_REF.child("requests").child(friendID).child(value).removeValue()
        }
        
        else {
            print("Send chat request")
            dataRequest.incrementCount(ref: FIREBASE_REF.child("users/\(userID)/requestsCount"))
            
            let friendRequestsRef = FIREBASE_REF.child("requests/\(friendID)")
            let autoID = friendRequestsRef.childByAutoId().key
            
            
            let request: [String: Any] = [
                "name": "Jae",
                "notificationID" : autoID,
                "questionID" : questionID,
                "timestamp" : "11-11",
                "uid" : "uid2"
            ]
            
            outgoingRequests.updateValue(autoID, forKey: questionID)
            friendRequestsRef.updateChildValues([autoID : request])

        }
    
        defaults.setOutgoingRequests(value: outgoingRequests)
    }
    
    func showMore(row: Int, sender: AnyObject) {
        
        guard let button = sender as? UIView else {
            return
        }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy

//        let question = questions[row]
        
        let hide = UIAlertAction(title: "Hide", style: .default, handler: { (action:UIAlertAction) in
            
            
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
    
    func doubleTapped(_ gestureReconizer: UITapGestureRecognizer) {
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            guard let cell = self.collectionView.cellForItem(at: index) as? QuestionCell else { return }
            cell.selectButton(cell.chatButton)
            // request chat to this user
            requestChat(row: index.row)
        
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
        
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let _ = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let question = questions[indexPath.row]

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
        cell.upvoteButton.setImage(#imageLiteral(resourceName: "upvote"), for: .normal)
        cell.upvoteButton.setImage(#imageLiteral(resourceName: "upvote"), for: .selected)
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
