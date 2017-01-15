//
//  RegisterFormViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class EmailViewController: FormViewController {
    
    override func setupViews() {
        super.setupViews()
        self.navigationItem.title = "Email"
        
        pageControl.currentPage = 1
        errorMessage = "Please enter a valid email"
        
        formLabel.text = "What's your email?"
        descLabel.text = "We won't send you spam."
        textField.placeholder = "Email Address"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
    }

    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        
        
        if let email = textField.text {
            
            if email.isEmail {
                checkEmails()
            }
            else {
                self.displayBanner(desc: "Please enter a valid email", color: .red)
            }
        }
        else {
            print("No characters inputted")
        }

    }
    
    
    func checkEmails() {
        nextButton.setTitle(nil, for: UIControlState())
        nextButton.isUserInteractionEnabled = false
        spinner.startAnimating()
        if var email = textField.text {
            
            email = email.lowercased().replacingOccurrences(of: ".", with: ",")
            let ref = FIREBASE_REF.child("userEmails")

            ref.child(email).observeSingleEvent(of: .value, with: { snapshot in
//            ref.queryEqual(toValue: email).queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in

                if snapshot.exists() {
                    print("email already exists.")
                    self.displayBanner(desc: "Email is already in use", color: .red)
                }
                else {
                    print("push view")
                    self.user.email = email.replacingOccurrences(of: ",", with: ".")
                    let passwordVC = PasswordViewController()
                    passwordVC.user = self.user
                    self.navigationController?.pushViewController(passwordVC, animated: true)

                }
                self.spinner.stopAnimating()
                self.nextButton.setTitle("Next", for: UIControlState())
                self.nextButton.isUserInteractionEnabled = true
            })
        }
        
    }
    
}

