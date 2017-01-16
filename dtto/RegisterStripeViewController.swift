//
//  RegisterStripeViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class RegisterStripeViewController: UIViewController {

    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Want to receive money from people who want to express their thanks?"
        label.textColor = Color.darkNavy
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var acceptButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Connect with Stripe", for: UIControlState())
        button.tintColor = .white
        button.backgroundColor = Color.darkNavy
        button.addTarget(self, action: #selector(accept), for: .touchUpInside)
        return button
    }()
    
    lazy var declineButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("I'd rather not", for: UIControlState())
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(decline), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(questionLabel)
        
        questionLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func decline() {
        dismiss(animated: true, completion: nil)
    }

    func accept() {
        // open webview
        if let email = FIRAuth.auth()?.currentUser?.email {
            
            if let url = URL(string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_9v7wtoubqFxBizTVcgtjD52ByeOsUzuQ&scope=read_write&stripe_user[email]=\(email)") {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(vc, animated: true)
            }
            
        }
        
        
    }
}
