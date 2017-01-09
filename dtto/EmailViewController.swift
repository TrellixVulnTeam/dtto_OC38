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
        errorMessage = "Please enter a valid email"
        
        formLabel.text = "What's your email?"
        descLabel.text = "We won't send you spam."
        textField.placeholder = "Email Address"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's name is \(user.name!)")
        
    }
    
    override func getUserInput(_ sender: UIButton) {
        
        if let email = textField.text {
            
            if isValidInput(text: email) {
                
                user.email = email
                let displayNameVC = DisplayNameViewController()
                displayNameVC.user = user
                navigationController?.pushViewController(displayNameVC, animated: true)
            }
            else {
                print("display error")
            }
        }
        else {
            print("No characters inputted")
        }

    }
    
    override func isValidInput(text: String) -> Bool {
        
        if text.characters.count < 2 {
            return false
        }
        
        return true
        
    }
    
}

