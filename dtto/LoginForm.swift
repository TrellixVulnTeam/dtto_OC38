//
//  LoginForm.swift
//  dtto
//
//  Created by Jitae Kim on 11/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController, UIGestureRecognizerDelegate {

    lazy var emailTextField: FloatingTextField = {
        let textField = FloatingTextField()
//        textField.iconText = "\u{f0e0}"
        textField.keyboardType = .emailAddress
        textField.delegate = self
        return textField
        
    }()
    
    lazy var passwordTextField: FloatingTextField = {
        let textField = FloatingTextField()
//        textField.iconText = "\u{f023}"
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    func createAccount(_ sender: Any) {
        
        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "CreateEmail") as! CreateEmail
        
        self.present(registerPage, animated: false, completion: nil)
        
        
    }
    
    // MARK: Tap Gesture to dismiss keyboard when not tapped on login button.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is GIDSignInButton {
            return false
        }
        return true
    }
    
    override func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }

    
    
}

extension EmailLoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = emailTextField.text else {
            return
        }
        
        
        if(!text.isEmail) {
            emailTextField.errorMessage = "Please enter a valid email."
        }
        else {
            // The error message will only disappear when we reset it to nil or empty string
            emailTextField.errorMessage = ""
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        switch textField {
            
        case emailTextField:
            _ = passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            print("User pressed enter, log in now.")
            
        default:
            break
        }
        
        return true
        
    }
}

extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}
