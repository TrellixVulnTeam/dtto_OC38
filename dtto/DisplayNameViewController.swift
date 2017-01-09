//
//  DisplayNameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class DisplayNameViewController: FormViewController {

    override func setupViews() {
        super.setupViews()
        self.title = "Display Name"
        pageControl.currentPage = 2
        errorMessage = "Please enter a valid displayName"
        
        formLabel.text = "What should we call you?"
        descLabel.text = "Your display name will be unique. You can change it later."
        textField.placeholder = "Display Name"
        nextButton.setTitle("Sign Up!", for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User's email is \(user.email!)")
        print("User's name is \(user.name!)")
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        if let displayName = textField.text {
            
            if displayName.characters.count > 1 {
                
                user.displayName = displayName
                // change root or something. sign in user
                
            }
            else {
                print("display error")
            }
            
        }
        else {
            print("No characters inputted")
        }
        
        
    }

}
