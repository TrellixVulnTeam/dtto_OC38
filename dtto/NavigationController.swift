//
//  NavigationController.swift
//  Chain
//
//  Created by Jitae Kim on 3/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    init(_ rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        addChildViewController(rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupviews()
    }
    
    func setupviews() {
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Color.darkNavy]
        navigationBar.tintColor = Color.darkNavy
        navigationBar.barTintColor = .white
    }

}
