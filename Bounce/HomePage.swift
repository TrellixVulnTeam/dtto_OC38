//
//  HomeCell.swift
//  Bounce
//
//  Created by Jitae Kim on 12/15/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class HomePage: BaseCollectionViewCell {
    
    var collectionView: UICollectionView!
    
    
    override func setupViews() {
        
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
    
    
    func doubleTapped(_ gestureReconizer: UITapGestureRecognizer) {
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            guard let cell = self.collectionView.cellForItem(at: index) as? QuestionCell else { return }
            cell.selectButton(cell.chatButton)
            // do stuff with your cell, for example print the indexPath
            
            print(index.row)
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
        
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
//        switch row {
//        case .Name:
//        case .Question:
//        case .Buttons:
//        case .Relates:
//            
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
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
