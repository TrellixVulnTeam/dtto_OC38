//
//  ResolveChatViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ResolveChatViewController: UIViewController {

    let resolveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Was username helpful?"
        return label
    }()
    
    lazy var helpfulButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Helpful", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(helped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var notHelpfulButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("-", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tintColor = .darkGray
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(notHelped(_:)), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.backgroundColor = Color.darkNavy
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func helped(_ sender: UIButton) {
        
    }
    
    func notHelped(_ sender: UIButton) {
        
    }
    
}
