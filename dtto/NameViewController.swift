//
//  NameViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class NameViewController: FormViewController {
    
    override func setupViews() {
        super.setupViews()
        self.title = "Name"
        pageControl.currentPage = 0
        errorMessage = ""
        
        formLabel.text = "What's your name?"
//        descLabel.text = "Full name"
        textField.placeholder = "Name"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

    override func checkInput(_ sender: AnyObject) {
        super.checkInput(sender)
        
        if isValidInput(textField) {
            self.user.name = textField.text!
            let nextVC = EmailViewController()
            nextVC.user = self.user
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        
    }
    
    override func isValidInput(_ textField: UITextField) -> Bool {
        
        if let textField = textField as? FloatingTextField, let text = textField.text {
            
            if text.characters.count < 2 || text.characters.count > 50 {
                errorMessage = "Please enter at least 2 characters."
                textField.errorMessage = "Please enter at least 2 characters."
                return false
            }
            else {
                errorMessage = ""
                textField.errorMessage = ""
                return true
            }
        }
        
        return false
        
    }

}
