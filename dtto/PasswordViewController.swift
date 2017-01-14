//
//  PasswordViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

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
    
//    lazy var confirmTextField: FloatingTextField = {
//        let textField = FloatingTextField()
//        textField.placeholder = "Confirm password"
//        textField.textColor = .black
//        textField.font = UIFont.systemFont(ofSize: 15)
//        textField.delegate = self
//        textField.autocapitalizationType = .words
//        textField.isSecureTextEntry = true
//        return textField
//    }()
    
    func togglePassword(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textField.isSecureTextEntry = false
//            confirmTextField.isSecureTextEntry = false
        }
        else {
            textField.isSecureTextEntry = true
//            confirmTextField.isSecureTextEntry = true
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.navigationItem.title = "Password"
        pageControl.currentPage = 1
        errorMessage = "Please enter at least 6 characters."
        
        formLabel.text = "You'll need a password."
        descLabel.text = "Make sure it's at least 6 characters."
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        
        nextButtonTopConstraint?.isActive = true
        
        view.addSubview(revealButton)
//        view.addSubview(confirmTextField)
        
        revealButton.anchor(top: nil, leading: view.leadingAnchor, trailing: nil, bottom: textField.topAnchor, topConstant: 0, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
//        nextButtonTopConstraint?.isActive = false
//        confirmTextField.anchor(top: textField.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nextButton.topAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's name is \(user.name!)")
        
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        createUser()
        
    }

    func createUser() {
        
        var errorText = ""
        
        if let email = user.email, let password = textField.text {
            
            if password == "" || password.characters.count < 6 {
                errorText = "Enter at least 6 characters."
//                self.displayBanner(desc: errorText)
            }
            
            else {
                spinner.startAnimating()
                nextButton.setTitle("", for: UIControlState())
                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil {
                        
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                                
                            case .errorCodeEmailAlreadyInUse:
                                errorText = "Email is already in use."
                                
                            case .errorCodeInvalidEmail:
                                errorText = "Email is invalid."
                                
                            case .errorCodeWeakPassword:
                                errorText = "Password is too weak."
                                
                            default:
                                errorText = "Could not connect to server."
                            }
                            self.spinner.stopAnimating()
                            self.nextButton.setTitle("Next", for: UIControlState())
                            self.displayBanner(desc: errorText)
                        }
                    }
                    else {

                        self.spinner.stopAnimating()
                        guard let user = user else { return }
                        
                        defaults.setUID(value: user.uid)
                        
                        self.user.email = email
                        let usernameVC = UsernameViewController()
                        usernameVC.user = self.user
                        self.navigationController?.pushViewController(usernameVC, animated: true)
                        
                    }
                }
                
            }
            
        }
        
    }
    
}
