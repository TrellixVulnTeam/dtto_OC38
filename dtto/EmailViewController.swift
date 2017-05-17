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
//                self.displayBanner(desc: "Please enter a valid email", color: .red)
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
        if let email = textField.text {
            
            let escapedEmail = email.lowercased().replacingOccurrences(of: ".", with: ",")

            FIREBASE_REF.child("userEmails").child("OI").observe(.value, with: { snapshot in
                print("WEFWEF")
            })
            
            FIREBASE_REF.child("userEmails").child(escapedEmail).observeSingleEvent(of: .value, with: { snapshot in

                if snapshot.exists() {
                    print("email already exists.")
//                    self.displayBanner(desc: "Email is already in use", color: .red)
                }
                else {
                    print("push view")
                    self.user.email = email
//                    self.user.email = email.replacingOccurrences(of: ",", with: ".")
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

