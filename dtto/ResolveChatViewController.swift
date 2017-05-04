//
//  ResolveChatViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Stripe

class ResolveChatViewController: UIViewController {
    
    let thanksLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you Jae, you just endorsed jitae for being helpful!"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    func setupViews() {
        
        view.backgroundColor = Color.darkNavy
        
        view.addSubview(thanksLabel)
        
        thanksLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ResolveChatViewController: UITextFieldDelegate {
    
    
}
