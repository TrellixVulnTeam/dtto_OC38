//
//  LoadPostViewController.swift
//  dtto
//
//  Created by Jitae Kim on 5/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadPostViewController: UIViewController {

    let postID: String
    let whiteView = UIView()
    let activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkSalmon, padding: 0)
    
    init(_ postID: String) {
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(whiteView)
        view.addSubview(activityIndicator)
        
        whiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        activityIndicator.anchorCenterSuperview()
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layoutIfNeeded()
        activityIndicator.startAnimating()
    }
    
    func getPost() {
        
//        POSTS_REF.child(postID).observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot)
//            if let post = Post(snapshot: snapshot) {
//                let vc = PostViewController(
//            }
//            
//        })
        
    }


}
