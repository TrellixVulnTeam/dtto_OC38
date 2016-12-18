//
//  Requests.swift
//  Bounce
//
//  Created by Jitae Kim on 12/17/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class Requests: BaseCollectionViewCell {

    var collectionView: UICollectionView!

    override func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        guard let collectionView = collectionView else { return }
//        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        print("Collectionviewheight \(collectionView.frame.height)")
        collectionView.register(RequestsCell.self, forCellWithReuseIdentifier: "RequestsCell")
    }
    

}


extension Requests: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return # of requests
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestsCell", for: indexPath) as! RequestsCell
        cell.backgroundColor = .white
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: collectionView.frame.height)
    }
    
}


class RequestsCell: BaseCollectionViewCell {
    
    let profile = UIImageView()
    
    override func setupViews() {
        super.setupViews()
        profile.image = #imageLiteral(resourceName: "acceptNormal")
        addSubview(profile)
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profile.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    
}

