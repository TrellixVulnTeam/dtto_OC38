//
//  Requests.swift
//  dtto
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class Requests: BaseCollectionViewCell {

    var collectionView: UICollectionView!
    var requests = [Notification]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Color.gray247
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.register(RequestsCell.self, forCellWithReuseIdentifier: "RequestsCell")

    }
    

}


extension Requests: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return # of requests
        return requests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestsCell", for: indexPath) as! RequestsCell
        cell.backgroundColor = .clear
        cell.name.text = requests[indexPath.item].name
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: collectionView.frame.height)
    }
    
}


class RequestsCell: BaseCollectionViewCell {
    
    let profile = RoundImageView()
    let name = UILabel()
    
    override func setupViews() {
        super.setupViews()
        profile.contentMode = .scaleAspectFill
        profile.image = #imageLiteral(resourceName: "profile")
        addSubview(name)
        addSubview(profile)
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profile.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profile.bottomAnchor, constant: 10).isActive = true
        name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    
}

