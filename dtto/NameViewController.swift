//
//  NameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class NameViewController: FormViewController {
    
    override func setupViews() {
        super.setupViews()
        self.title = "Name"
        errorMessage = ""
        
        formLabel.text = "What's your name?"
        descLabel.text = "Full name"
        textField.placeholder = "Name"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func getUserInput(_ sender: UIButton) {
        
        if let name = textField.text {
            
            if isValidInput(text: name) {
                
                user.name = name
                let emailVC = EmailViewController()
                emailVC.user = user
                navigationController?.pushViewController(emailVC, animated: true)
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
