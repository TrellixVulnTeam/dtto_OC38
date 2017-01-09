//
//  PasswordViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PasswordViewController: FormViewController {
    
    lazy var revealButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Reveal password", for: .normal)
        button.setTitle("Hide password", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.blue, for: UIControlState())
        button.addTarget(self, action: #selector(togglePassword(_:)), for: .touchUpInside)
        return button
    }()
    
    func togglePassword(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textField.isSecureTextEntry = false
        }
        else {
            textField.isSecureTextEntry = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.title = "Password"
        pageControl.currentPage = 1
        errorMessage = "Please enter at least 6 characters."
        
        formLabel.text = "You'll need a password."
        descLabel.text = "Make sure it's at least 6 characters."
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        
        view.addSubview(revealButton)
        
        revealButton.anchor(top: nil, leading: view.leadingAnchor, trailing: nil, bottom: textField.topAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's name is \(user.name!)")
        
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        if let password = textField.text {
            
            _ = isValidInput(text: password)

        }
        else {
            print("No characters inputted")
        }
        
    }
    
    override func isValidInput(text: String) -> Bool {
        
        if text.characters.count < 6 {
            textField.errorMessage = "Enter at least 6 characters"
            return false
        }
        else {
            textField.errorMessage = ""
            return true
        }
    }
    
    
}
