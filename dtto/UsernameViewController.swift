//
//  DisplayNameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class DisplayNameViewController: FormViewController {

    override func setupViews() {
        super.setupViews()
        self.title = "DisplayName"
        errorMessage = "Please enter a valid displayName"
        
        formLabel.text = "What should we call you?"
        descLabel.text = "Your displayName will be unique. You can change it later"
        textField.placeholder = "DisplayName"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's email is \(user.email!)")
        print("User's name is \(user.name!)")
    }
    
    override func getUserInput(_ sender: UIButton) {
        
        if let displayName = textField.text {
            
            if isValidInput(text: displayName) {
                
                user.displayName = displayName
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
            errorMessage = "Please enter at least 2 characters." // no spaces, only letters, numbers, underscores
            return false
        }
        else {
            
            return true
        }
        
        
    }

}
