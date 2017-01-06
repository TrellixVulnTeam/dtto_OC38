//
//  HomeCell.swift
//  dtto
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

protocol PostProtocol : class {
    func requestChat(row: Int, chatState: ChatState)
    func relatePost(row: Int)
    func showMore(section: Int, sender: AnyObject)
}

class HomePage: BaseCollectionViewCell, PostProtocol {
    
    var posts = [Question]()
    var fullPosts = [Question]()
    
    var collectionView: UICollectionView!
    
    override func setupViews() {
        
        observeQuestions()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

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
        
        collectionView.register(PostProfileCell.self, forCellWithReuseIdentifier: "PostProfileCell")
        collectionView.register(PostTextCell.self, forCellWithReuseIdentifier: "PostTextCell")
        collectionView.register(PostButtonsCell.self, forCellWithReuseIdentifier: "PostButtonsCell")
        collectionView.register(PostTagsCell.self, forCellWithReuseIdentifier: "PostTagsCell")
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
                if let displayName = questionData["displayName"] as? String {
                    question.displayName = displayName
                }
                
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
//                
//                let hiddenPosts = defaults.getHiddenPosts()
//                if hiddenPosts.count == 0 || hiddenPosts[questionID] == nil {
//                    print("question is not hidden")
//                    self.posts.insert(question, at: 0)
//
//                }
                self.posts.insert(question, at: 0)
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
    
    func showMore(section: Int, sender: AnyObject) {
        
        guard let button = sender as? UIView else {
            return
        }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = Color.darkNavy

        let question = posts[section]
        
        let hide = UIAlertAction(title: "Hide", style: .default, handler: { (action:UIAlertAction) in
            
            self.hidePost(section: section, questionID: question.questionID)
            
        })
        ac.addAction(hide)
        
        let report = UIAlertAction(title: "Report", style: .destructive, handler: { (action:UIAlertAction) in
            
            self.reportPost(questionID: question.questionID)
            
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
    
    func hidePost(section: Int, questionID: String?) {
        
        if let questionID = questionID {
            
            defaults.hidePost(postID: questionID)
            self.collectionView.performBatchUpdates({
                self.posts.remove(at: section)
                self.collectionView.deleteSections(IndexSet(integer: section))
            }, completion: nil)
            
        }
        
    }
    
    func reportPost(questionID: String?) {
        
        if let questionID = questionID {
            
            let dataRequest = FirebaseService.dataRequest
            let reportsRef = FIREBASE_REF.child("reports").child(questionID)
            dataRequest.incrementCount(ref: reportsRef.child("reportsCount"))
 
        }
    }
    
    func doubleTapped(_ gestureReconizer: UITapGestureRecognizer) {
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            guard let _ = self.collectionView.cellForItem(at: index) as? PostTextCell else { return }
            guard let cell = self.collectionView.cellForItem(at: IndexPath(row: 2, section: index.section)) as? PostButtonsCell else { return }
            // request chat to this user
            cell.selectButton(cell.chatButton)
//            requestChat(row: index.row, chatState: cell.chatState)
        
        } else {
            print("Could not find index path")
        }
    }
    
    func showProfile(section: Int) {
        
        let post = posts[section]
        
        let user = User()
        user.name = post.name
        user.displayName = post.displayName
        user.uid = post.userID
        
        let profileVC = ProfileViewController(user: user)
        masterViewDelegate?.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}

extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Row: Int {
        
        case Profile
        case Post
        case Buttons
        case Relates
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        let question = posts[indexPath.section]
        
        switch row {
            
        case .Profile:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCell", for: indexPath) as! PostProfileCell
            cell.nameLabel.text = "Jitae Kim"
            cell.usernameLabel.text = "@jitae"
            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            cell.postDelegate = self
            cell.moreButton.tag = indexPath.section
            return cell
            
        case .Post:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTextCell", for: indexPath) as! PostTextCell
            cell.postLabel.text = "text up to 200 characters here. text up to 200 characters here. text up to 200 characters here. text up to 200 characters here."
            return cell
            
        case .Buttons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostButtonsCell", for: indexPath) as! PostButtonsCell
            return cell
            
        case .Relates:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostTagsCell", for: indexPath) as! PostTagsCell
            cell.relatesCount = 2
            return cell
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
        guard let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
        case .Profile:
            let post = posts[indexPath.section]
            if !post.isAnonymous {
                showProfile(section: indexPath.section)
            }
            
            print("push profile")
        case .Relates:
            print("push people related")
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cell = collectionView.cellForItem(at: indexPath)
//        let height = cell!.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        guard let row = Row(rawValue: indexPath.row) else { return CGSize() }
        
        switch row {
        case .Profile:
            return CGSize(width: collectionView.frame.width, height: 70)
        case .Post:
            return CGSize(width: collectionView.frame.width, height: 100)
        case .Buttons:
            return CGSize(width: collectionView.frame.width, height: 50)
        case .Relates:
            return CGSize(width: collectionView.frame.width, height: 50)
            
        }
        
    }
    


}

extension HomePage: UIGestureRecognizerDelegate {
    
}
