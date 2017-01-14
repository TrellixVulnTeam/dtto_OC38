//
//  CardRegistrationViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SafariServices

class CardRegistrationViewController: UIViewController {

    var user = User()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Want to receive money from people who express their thanks?"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "dtto lets users send money to people who helped them."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let assuranceLabel: UILabel = {
        let label = UILabel()
        label.text = "dtto takes a percentage for providing services."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let poweredByStripeLabel: UILabel = {
        let label = UILabel()
        label.text = "Powered by Stripe"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var registerStripeButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.backgroundColor = Color.darkNavy
        button.tintColor = .white
        button.setTitle("Sure", for: UIControlState())
//        button.setBackgroundImage(#imageLiteral(resourceName: "poweredByStripe"), for: UIControlState())
        button.addTarget(self, action: #selector(registerStripe(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var notNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Not now", for: UIControlState())
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(goHome(_:)), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(descLabel)
        view.addSubview(registerStripeButton)
//        view.addSubview(poweredByStripeLabel)
        view.addSubview(notNowButton)
        
        headerLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 50, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        headerLabel.anchorCenterXToSuperview()
        
        descLabel.anchor(top: headerLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        descLabel.anchorCenterXToSuperview()
        
        registerStripeButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 30, trailingConstant: 30, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        registerStripeButton.anchorCenterSuperview()
        
//        poweredByStripeLabel.anchor(top: registerCardButton.bottomAnchor, leading: nil, trailing: registerCardButton.trailingAnchor, bottom: nil, topConstant: 5, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        notNowButton.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func goHome(_ sender: UIButton) {
        // change root view, dismiss login flow
        changeRootVC(vc: .login)
    }
    
    func registerStripe(_ sender: UIButton) {
        if let url = URL(string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_9v7wtoubqFxBizTVcgtjD52ByeOsUzuQ&scope=read_write&stripe_user[email]=jitaekim93@gmail.com") {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
        
    }

}
