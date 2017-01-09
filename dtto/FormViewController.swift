//
//  FormViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    var user = User()
    
    let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var textField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.delegate = self
        return textField
    }()
    
    lazy var nextButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Next", for: UIControlState())
        button.backgroundColor = Color.darkNavy
        button.tintColor = .white
        button.addTarget(self, action: #selector(getUserInput(_:)), for: .touchUpInside)
        return button
    }()
    
    var errorMessage: String = String()
    
    func setupViews() {
        
        view.backgroundColor = .white

        view.addSubview(formLabel)
        view.addSubview(descLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
        
        formLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        descLabel.anchor(top: formLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        textField.anchor(top: descLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        nextButton.anchor(top: textField.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func getUserInput(_ sender: UIButton) {
        
    }
    
    func isValidInput(text: String) -> Bool {
        return false
    }
    
    
    
}

extension FormViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = self.textField.text {
            
            if(!isValidInput(text: text)) {
                self.textField.errorMessage = errorMessage
            }
            
            else {
                self.textField.errorMessage = ""
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        _ = textField.resignFirstResponder()
        return true
    }
    
    
}

