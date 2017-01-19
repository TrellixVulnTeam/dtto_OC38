//
//  NameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class NameViewController: FormViewController {
    
    lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissLogin(_:)))
        return button
        
    }()
    
    override func setupViews() {
        super.setupViews()
        self.navigationItem.title = "Name"
        pageControl.currentPage = 0
        errorMessage = ""
        
        formLabel.text = "Hi. What's your name?"
        descLabel.text = "You can change or hide this later."
        textField.placeholder = "Name"
        self.navigationItem.leftBarButtonItem = dismissButton
        
    }

    func dismissLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        
        if isValidInput(textField) {
            
            if let name = textField.text {
                self.user.name = name
                let nextVC = EmailViewController()
                nextVC.user = self.user
                self.navigationController!.pushViewController(nextVC, animated: true)
            }
            
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
