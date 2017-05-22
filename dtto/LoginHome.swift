//
//  LoginHome.swift
//  dtto
//
//  Created by Jitae Kim on 11/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
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
    
    lazy var loginButton: UIButton = {
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
        let registerVC = NavigationController(NameViewController())
        present(registerVC, animated: true, completion: nil)
        
    }
    
    func emailLogin(_ sender: UIButton) {
        let emailLoginVC = NavigationController( EmailLoginViewController())
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
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
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
        
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }

        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            if let user = user {
                
                let userID = user.uid
                defaults.setUID(value: userID)
                
                // upload token.
                if let fcmToken = InstanceID.instanceID().token() {
                    USERS_REF.child(userID).child("notificationTokens").child(fcmToken).setValue(true)
                }
                
                if let name = user.displayName {
                    defaults.setName(value: name)
                }
                
                // TODO: Check if new or returning user.
                // see if user created username.
                
                PROFILES_REF.child(userID).child("username").observeSingleEvent(of: .value, with: { snapshot in
                    
                    if snapshot.exists() {
                        self.changeRootVC(vc: .login)
                    }
                    else {
                        // TODO: Prompt username screen, not home screen.

                    }
                    
                })
                
            }
            
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
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        // check if user logged in with another provider
        
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errorCode {
                    case .emailAlreadyInUse:
                        break
                    default:
                        print("this error needs to be fixed")
                    }
                    
                }
                return
            }
            
            if let user = user {
                
                defaults.setUID(value: user.uid)
                if let name = user.displayName {
                    defaults.setName(value: name)
                }
                
                // upload token.
                if let fcmToken = InstanceID.instanceID().token() {
                    USERS_REF.child(user.uid).child("notificationTokens").child(fcmToken).setValue(true)
                }
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                
                let _ = request?.start(completionHandler: { (connection, result, error) in
                    
                    guard let userInfo = result as? [String: Any] else { return } //handle the error
                    
                    if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String, let url = URL(string: imageURL) {
                        
                        //Download image from imageURL
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                            }
                            
                            if let data = data {
                                // upload to firebase storage.
                                
                                let profileImageRef = STORAGE_REF.child("users").child(user.uid).child("profile.jpg")
                                
                                profileImageRef.putData(NSData(data: data) as Data, metadata: nil) { metadata, error in
                                    if (error != nil) {
                                        
                                    } else {
                                        // successfully uploaded to user/profile.jpg
                                        profileImageRef.downloadURL { url, error in
                                            if let _ = error {
                                                // Handle any errors
                                            } else {
                                                let changeRequest = user.createProfileChangeRequest()
                                                changeRequest.photoURL = url
                                                changeRequest.commitChanges { error in
                                                    if let _ = error {
                                                        print("could not set user's profile")
                                                    } else {
                                                        print("user's profile updated")
                                                    }
                                                }

                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        })
                        task.resume()
                    }
                })
            }
                
            
            // TODO: Prompt username screen, not home screen.
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



