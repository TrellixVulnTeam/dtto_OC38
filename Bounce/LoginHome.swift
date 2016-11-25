//
//  LoginHome.swift
//  Bounce
//
//  Created by Jitae Kim on 11/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit
import Firebase

class LoginHome: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var emailTextField: FloatingTextField! {
        didSet {
            emailTextField.iconText = "\u{f0e0}"
            emailTextField.keyboardType = .emailAddress
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: FloatingTextField! {
        didSet {
            passwordTextField.iconText = "\u{f023}"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
        }
    }

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton! {
        didSet {
            facebookLoginButton.readPermissions = ["email", "public_profile"]
        }
    }
    
    @IBAction func emailLogin(_ sender: Any) {
        self.view.endEditing(true)
        let email = emailTextField.text
        let pw = passwordTextField.text
        
        if (email != "" && pw != "") {
//            loginSpinner.startAnimating()
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: pw!) { (user, error) in
                if error != nil {
                    
//                    if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
//                        switch (errorCode) {
//                            
//                        case .errorCodeUserNotFound:
//                            self.errorLabel.text = "계정이 틀렸습니다."
//                            
//                        case .errorCodeInvalidEmail:
//                            self.errorLabel.text = "계정 형식이 맞지 않습니다."
//                            
//                        case .errorCodeWrongPassword:
//                            self.errorLabel.text = "비밀번호가 틀렸습니다."
//                            
//                        default:
//                            self.errorLabel.text = "로그인을 못 하였습니다."
//                        }
//                        self.errorLabel.fadeOut(withDuration: 0.2)
//                        self.errorLabel.fadeIn(withDuration: 0.5)
//                    }
                    
                    
                } else {
                    
                    guard let user = user else {
                        return
                    }
                    
//                    if let nickName = user.displayName {
//                        defaults.setName(value: nickName)
//                    }
//                    defaults.setLogin(value: true)
//                    defaults.setUID(value: user.uid)
//                    defaults.setEditPermissions(value: true)
//                    defaults.setImagePermissions(value: true)
//                    
//                    getFavorites()
                    
                    self.changeRootVC(vc: .login)
                    
                    
                }
//                self.loginSpinner.stopAnimating()
            }
        }
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "CreateEmail") as! CreateEmail
        
        self.present(registerPage, animated: false, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLoginButton.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topConstraint.constant -= self.view.bounds.size.height
        bottomConstraint.constant -= self.view.bounds.size.height
//        emailTextField.center.y -= self.view.bounds.size.height
//        facebookLoginButton.center.y += self.view.bounds.size.height
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topConstraint.constant = 50
        bottomConstraint.constant = 50
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginHome: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = emailTextField.text else {
            return
        }
        
        guard let floatingLabelTextField = emailTextField else {
            return
        }
        
        if(!text.isEmail) {
            floatingLabelTextField.errorMessage = "Please enter a valid email."
        }
        else {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
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

extension LoginHome: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
            
            self.changeRootVC(vc: .login)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        self.changeRootVC(vc: .logout)
    }

    
}

extension LoginHome: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
            self.changeRootVC(vc: .login)
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
        
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

