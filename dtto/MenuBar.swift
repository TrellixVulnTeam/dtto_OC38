//
//  MenuBar.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class MenuBar: UIView {

//    var parentController: CollectionViewWithMenu?
    var numberOfItems: Int = 2
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40), collectionViewLayout: layout)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "menuCell")
        let firstItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstItem, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)

        setupViews()
        setupBottomBorder()
        setupHorizontalBar()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        addSubview(collectionView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupBottomBorder() {
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = Color.lightGray

        addSubview(bottomBorderView)
        bottomBorderView.anchor(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 1)

    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.lightGreen
        
        addSubview(horizontalBarView)
        
        horizontalBarView.anchor(top: nil, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 2)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
//        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: CGFloat(1)/CGFloat(numberOfItems), constant: -20).isActive = true
//        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }
    
    func setupSectionSeparator() {
        let line = UIView()
        line.backgroundColor = Color.lightGray

        addSubview(line)
        
        line.anchor(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 5, widthConstant: 1, heightConstant: 0)

        
    }
    
}


extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.backgroundColor = .white
        if indexPath.row != 0 {
            cell.nameLabel.textColor = Color.textGray
        }
        cell.nameLabel.text = "Posts"

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        parentController?.scrollToMenuIndex(indexPath.item)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / CGFloat(numberOfItems), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

class MenuCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .black
            }
            else {
                nameLabel.textColor = Color.textGray
            }
        }
    }
    func setupViews() {
        
        addSubview(nameLabel)
        nameLabel.anchorCenterSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
