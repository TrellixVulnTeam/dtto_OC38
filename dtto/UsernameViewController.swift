//
//  usernameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class UsernameViewController: FormViewController {
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = "Username"
        navigationItem.hidesBackButton = true
        
        pageControl.currentPage = 3
        errorMessage = "Please enter a valid username"
        
        formLabel.text = "What should we call you?"
        descLabel.text = "Your username will be unique. You can change it later."
        textField.placeholder = "Username"
        nextButton.setTitle("Sign Up!", for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("User's email is \(user.email!)")
//        print("User's name is \(user.name!)")
    }
    
    func checkUsername() {
        
        guard let username = textField.text else { return }
        
        let usernameRef = FIREBASE_REF.child("usernames").child(username)
        usernameRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
//                self.displayBanner(desc: "Username is already taken", color: .red)
            }
            else {
                
                self.user.username = username
                defaults.setName(value: self.user.name!)
                defaults.setUsername(value: username)
                self.addUniqueUser()
                self.updateUser()
                
                self.changeRootVC(vc: .login)
//                let cardVC = CardRegistrationViewController()
//                cardVC.user = self.user
//                self.present(cardVC, animated: true, completion: {
//                    self.navigationController?.viewControllers.removeAll()
//                })
//                
                

            }
            
        })
    }
    
    // This adds the username and email so that no one else can claim it.
    func addUniqueUser() {
        
        guard let username = self.user.username, let email = self.user.email else { return }
        
        let usernamesRef = FIREBASE_REF.child("usernames").child(username)
        usernamesRef.setValue(true)
        
        
        if let escapedEmail = email.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.replacingOccurrences(of: ".", with: "%2E") {
            
            let userEmailsRef = FIREBASE_REF.child("userEmails").child(escapedEmail)
            userEmailsRef.setValue(true)
            
        }
        
        
        
        
    }
    
    // Create initial user data
    func updateUser() {
        
        guard let user = FIRAuth.auth()?.currentUser else { return }
        
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = self.user.name!
        changeRequest.commitChanges { error in
            if let _ = error {
                print("could not set user's name")
            } else {
                print("user's name updated")
                user.sendEmailVerification(completion: { (error) in
                    
                    if error != nil {
                        
                    }
                    print("Sent email")
                    // ...
                })
            }
        }
        
        let userRef = FIREBASE_REF.child("users").child(user.uid)
        
        var userData = [String : Any]()
        
        // Setup user's personal info
        if let name = self.user.name, let email = self.user.email, let username = self.user.username {
            userData.updateValue(name, forKey: "name")
            userData.updateValue(email, forKey: "email")
            userData.updateValue(username, forKey: "username")
        }
        
        // Setup stats for future use
        let userStats = ["answerCount", "ongoingChatAcceptedCount", "ongoingChatCount", "ongoingChatRequestedCount", "postCount", "helpsReceivedCount", "helpsGivenCount", "relatesGivenCount", "relatesReceivedCount", "requestsCount", "shareCount", "totalChatCount", "totalChatRequestsCount", "tipsGivenCount", "tipsReceivedCount", "totalTipGiven", "totalTipReceived"]
        
        for key in userStats {
            userData.updateValue(0, forKey: key)
        }
        
        userRef.updateChildValues(userData)
        
    }
    
    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        
        if isValidInput(textField) {
            checkUsername()
        }
        
    }
    
    override func isValidInput(_ textField: UITextField) -> Bool {
        
        if let textField = textField as? FloatingTextField, let text = textField.text {
            
            switch text.characters.count {
                
            case 0:
                errorMessage = "Please enter your name."
                textField.errorMessage = "Please enter your name."
                return false
            case 21..<Int.max:
                errorMessage = "Please enter up to 20 characters."
                textField.errorMessage = "Please enter up to 20 characters."
                return false
            default:
                errorMessage = ""
                textField.errorMessage = ""
                return true
            }
            
        }
        
        return false
    }

}

