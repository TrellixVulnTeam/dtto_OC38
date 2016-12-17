//
//  MenuBar.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class MenuBar: UIView {

    let menuHeight : CGFloat = 40
    var parentController: CollectionViewWithMenu?
    var numberOfItems: Int = 2
//    var menuType: menuType?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40), collectionViewLayout: layout)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        let firstItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: firstItem, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfItems = 3
        
//        setupMenuBar()
        addSubview(collectionView)
        setupBottomBorder()
        setupHorizontalBar()
        
        
    }
    /*
    
    init(frame: CGRect, menuType: menuType) {
        super.init(frame: frame)
        self.menuType = menuType
        switch menuType {
            case .AbilityList:
                numberOfItems = 2
            case .AbilityView:
                numberOfItems = 5
            case .TavernList:
                numberOfItems = 3
        }
        
        addSubview(collectionView)
        setupBottomBorder()
        setupHorizontalBar()
        
    }
*/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var horizontalBarWidthConstraint: NSLayoutConstraint?
    
    func setupMenuBar() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupBottomBorder() {
        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = Color.lightGray
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorderView)
        bottomBorderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomBorderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomBorderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.salmon
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: 50)
        horizontalBarWidthConstraint?.isActive = true
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }
    
    func setupSectionSeparator() {
        let line = UIView()
        line.backgroundColor = Color.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        line.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
}


extension MenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum Row: Int {
        case Notifications
        case Home
        case Chat
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let row = Row(rawValue: indexPath.row) else { return UICollectionViewCell() }
        
        switch row {
            
        case .Notifications:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.image.image = #imageLiteral(resourceName: "notification")
            return cell
            
        case .Home:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.label.text = "Dtto"
            return cell
            
        case .Chat:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.image.image = #imageLiteral(resourceName: "chat")
            return cell
        }

        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        parentController?.scrollToMenuIndex(indexPath.item)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let row = Row(rawValue: indexPath.item) else { return CGSize() }
        
        switch row {
        case .Notifications, .Chat:
            return CGSize(width: 50, height: frame.height)
        case .Home:
            return CGSize(width: frame.width - 100, height: frame.height)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

//class MenuCell: UICollectionViewCell {
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//
//    func setupViews() {
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

