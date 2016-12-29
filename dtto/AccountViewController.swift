//
//  AccountViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/24/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    var user: User?
    
    private func observeUser() {
        print("GETTING USER INFO...")
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let userRef = FIREBASE_REF.child("users/\(userID)")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUser()
    }

}
