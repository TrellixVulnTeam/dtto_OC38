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
        pageControl.currentPage = 0
        errorMessage = ""
        
        formLabel.text = "What's your name?"
//        descLabel.text = "Full name"
        textField.placeholder = "Name"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        if let name = textField.text {
            
            if isValidInput(text: name) {
                
                user.name = name
                let emailVC = EmailViewController()
                emailVC.user = user
                navigationController?.pushViewController(emailVC, animated: true)
            }

        }
        
    }
    
    override func isValidInput(text: String) -> Bool {
        
        if text.characters.count < 2 || text.characters.count > 50 {
            errorMessage = "Please enter at least 2 characters."
            textField.errorMessage = "Please enter at least 2 characters."
            return false
        }
        else {
            errorMessage = ""
            textField.errorMessage = ""
            return true
        }
        
        
        
    }

}
