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
        self.title = "Email"
        pageControl.currentPage = 1
        errorMessage = "Please enter a valid email"
        
        formLabel.text = "What's your email?"
        descLabel.text = "We won't send you spam."
        textField.placeholder = "Email Address"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's name is \(user.name!)")
        
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
    
    override func isValidInput(text: String) -> Bool {
        
        if text.isEmail {
            return true
        }
        else {
            textField.errorMessage = "Please enter a valid email"
            return false
        }
    }
    
    func checkEmails() {
        nextButton.setTitle(nil, for: UIControlState())
        nextButton.isUserInteractionEnabled = false
        spinner.startAnimating()
        if let email = textField.text?.lowercased() {
            let ref = FIREBASE_REF.child("userEmails")

            ref.queryEqual(toValue: email).queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in

                if snapshot.hasChildren() {
                    print("email already exists.")
                    self.displayBanner(desc: "Email is already in use", color: .red)
                }
                else {
                    print("push view")
                    self.user.email = email
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

