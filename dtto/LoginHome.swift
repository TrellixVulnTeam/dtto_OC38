//
//  LoginHome.swift
//  dtto
//
//  Created by Jitae Kim on 11/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FBSDKLoginKit
import Firebase
import NVActivityIndicatorView

class LoginHome: UIViewController, UIGestureRecognizerDelegate {

    var initialLoad = true
    var topConstraint = NSLayoutConstraint()
    var bottomConstraint: NSLayoutConstraint!

    let headerView: LoginHeaderView = LoginHeaderView()
    
    lazy var facebookLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    var googleLoginButton: GIDSignInButton = GIDSignInButton()
    
    lazy var registerEmailButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Sign Up With Email", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.tintColor = .white
        button.backgroundColor = Color.darkNavy
        button.addTarget(self, action: #selector(registerUser(_:)), for: .touchUpInside)
        return button
    }()
    
    var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(emailLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    let spinner: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkNavy, padding: 0)
        return spinner
    }()
    
    func registerUser(_ sender: UIButton) {
        let registerVC = UINavigationController(rootViewController: NameViewController())
        present(registerVC, animated: true, completion: nil)
        
    }
    
    func emailLogin(_ sender: UIButton) {
        let emailLoginVC = UINavigationController(rootViewController: EmailLoginViewController())
        present(emailLoginVC, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        let bar = TextWithHorizontalBars(string: "OR")
        let bottomBar = HorizontalBar()
        
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(facebookLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(bar)
        view.addSubview(registerEmailButton)
        view.addSubview(bottomBar)
        view.addSubview(loginButton)
//        view.addSubview(spinner)
        
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        topConstraint = facebookLoginButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20)
        topConstraint.isActive = true
        facebookLoginButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        googleLoginButton.anchor(top: facebookLoginButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        bar.anchor(top: googleLoginButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        registerEmailButton.anchor(top: bar.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        bottomBar.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 1.0/UIScreen.main.scale)
        loginButton.anchor(top: bottomBar.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 20, trailingConstant: 20, bottomConstant: 10, widthConstant: 0, heightConstant: 0)
        
//        spinner.anchorCenterSuperview()
//        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLoginButton.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if initialLoad {
//            topConstraint.constant += self.view.bounds.size.height
//            self.view.layoutIfNeeded()
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
////        if initialLoad {
////            topConstraint.constant = 20
////            
////            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
////                
////                self.view.layoutIfNeeded()
////                self.initialLoad = false
////            }, completion: nil)
////        }
//        
    }
    
    func animateUserLogin() {
        
        let whiteView = UIView()
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

}


extension LoginHome: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        googleLoginButton.isUserInteractionEnabled = false
        
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
//        spinner.startAnimating()
        animateUserLogin()
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
            defaults.setLogin(value: true)
            defaults.setUID(value: uid)
            self.changeRootVC(vc: .login)
        })
        
        googleLoginButton.isUserInteractionEnabled = true
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
        
        // check if user logged in with another provider
        
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errorCode {
                    case .errorCodeEmailAlreadyInUse:
                        break
                    default:
                        print("this error needs to be fixed")
                    }
                    
                }
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
            guard let user = user else {
                return
            }
            
            defaults.setLogin(value: true)
            defaults.setUID(value: user.uid)
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



