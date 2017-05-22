//
//  LoginForm.swift
//  dtto
//
//  Created by Jitae Kim on 11/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

let FORGOTPASSWORD_TITLE = "Enter you email."
let FORGOTPASSWORD_MESSAGE = "You will be sent a password reset email."

class EmailLoginViewController: UIViewController, UIGestureRecognizerDelegate {

    lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissLogin(_:)))
        return button
        
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to dtto"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.placeholder = "Email Address"
//        textField.iconText = "\u{f0e0}"
        textField.keyboardType = .emailAddress
        textField.delegate = self
        return textField
        
    }()
    
    lazy var passwordTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 15)

//        textField.iconText = "\u{f023}"
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    lazy var loginButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Log in", for: UIControlState())
        button.backgroundColor = Color.darkNavy
        button.tintColor = .white
        button.addTarget(self, action: #selector(emailLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var forgotButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Forgot password?", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .white
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        return button
    }()
    
    let spinner: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkNavy, padding: 0)
        return spinner
    }()
    
    let whiteView = UIView()
    
    func setupViews() {
        
        self.navigationItem.title = "Log In"
        self.navigationItem.leftBarButtonItem = dismissButton
        view.backgroundColor = .white
        
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotButton)
        
        loginLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        emailTextField.anchor(top: loginLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        loginButton.anchor(top: passwordTextField.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        forgotButton.anchor(top: loginButton.bottomAnchor, leading: nil, trailing: loginButton.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    func dismissLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func emailLogin(_ sender: AnyObject) {

        if let email = emailTextField.text, let password = passwordTextField.text {
            
            self.animateUserLogin()
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error != nil {
                    
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        
                        var errorText = ""
                        
                        switch errorCode {
                            
                        case .userNotFound:
                            errorText = "Sorry, we couldn't find an account with that email."
                            
                        case .invalidEmail:
                            errorText = "Please enter a valid email"
                            
                        case .wrongPassword:
                            errorText = "The password you've entered is incorrect."
                            
                        default:
                            errorText = "Could not connect to server."
                        }
                        print(errorText)
                        
//                        self.displayBanner(desc: errorText)
                        
                    }
                }
                
                else {
                    guard let user = Auth.auth().currentUser else { return }
                    defaults.setUID(value: user.uid)
                    defaults.setLogin(value: true)
                    if let refreshedToken = InstanceID.instanceID().token() {
                        USERS_REF.child(user.uid).child("notificationTokens").child(refreshedToken).setValue(true)

                    }

                    if let name = user.displayName {
                        defaults.setName(value: name)
                    }
                    let usernameRef = PROFILES_REF.child(user.uid).child("username")
                    usernameRef.observeSingleEvent(of: .value, with: { snapshot in

                        if let username = snapshot.value as? String {
                            defaults.setUsername(value: username)
                        }
                    })
                    
                    self.changeRootVC(vc: .login)
                    
                }
                
                self.removeSpinner()
            }
            
        }
        
    }
    
    func forgotPassword() {
        
        let ac = UIAlertController(title: FORGOTPASSWORD_TITLE, message: FORGOTPASSWORD_MESSAGE, preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        ac.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { action in
            let textField = ac.textFields![0] as UITextField
            if let email = textField.text {
                if email.isEmail {
                    Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
                }
            }
        })
        
        ac.addAction(confirmAction)
        
        ac.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Email"
        })
        
        present(ac, animated: true, completion: nil)
        
    }

    func animateUserLogin() {
        
        whiteView.backgroundColor = .white
        
        view.addSubview(whiteView)
        whiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(spinner)
        spinner.anchorCenterSuperview()
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layoutIfNeeded()
        spinner.startAnimating()
        
    }
    
    func removeSpinner() {
        whiteView.removeFromSuperview()
        spinner.removeFromSuperview()
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
            emailLogin(self)
            
        default:
            break
        }
        
        return true
        
    }
}
//
//extension EmailLoginViewController: DisplayBanner {
//    
//}

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
