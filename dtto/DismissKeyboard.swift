//
//  DismissKeyboard.swift
//  dtto
//
//  Created by Jitae Kim on 11/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
