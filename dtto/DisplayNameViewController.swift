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
        self.navigationItem.title = "Display Name"
        pageControl.currentPage = 2
        errorMessage = "Please enter a valid display name"
        
        formLabel.text = "What should we call you?"
        descLabel.text = "Your display name will be unique. You can change it later."
        textField.placeholder = "Display Name"
        nextButton.setTitle("Sign Up!", for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("User's email is \(user.email!)")
//        print("User's name is \(user.name!)")
    }
    
    func checkDisplayName() {
        let displayNameRef = FIREBASE_REF.child("displayNames").child(textField.text!)
        displayNameRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                self.displayBanner(desc: "Display name is already taken", color: .red)
            }
            else {
//                user.displayName = displayName
                // push next vc
//                let educationVC =
            }
            
        })
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        if let displayName = textField.text {
            
            if displayName.characters.count > 1 {
                
                checkDisplayName()
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
    
    /*
 let changeRequest = user.profileChangeRequest()
 changeRequest.displayName = nickname
 changeRequest.commitChanges { error in
 if let _ = error {
 print("could not set user's nickname")
 } else {
 print("user's nickname updated")
 }
 }
*/

}
