//
//  FormViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/8/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FormViewController: UIViewController {
    
    var user = User()
    
    let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.delegate = self
        textField.autocapitalizationType = .words
        return textField
    }()
    
    lazy var nextButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Next", for: UIControlState())
        button.backgroundColor = Color.darkNavy
        button.tintColor = .white
        button.addTarget(self, action: #selector(checkInput(_:)), for: .touchUpInside)
        return button
    }()
    
    let spinner: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballScaleRippleMultiple, color: .white, padding: 0)
        return spinner
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = Color.lightGray
        pageControl.currentPageIndicatorTintColor = Color.darkNavy
        pageControl.numberOfPages = 4
        return pageControl
    }()
    
    var errorMessage: String = String()
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(formLabel)
        view.addSubview(descLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
        nextButton.addSubview(spinner)
        view.addSubview(pageControl)
        
        formLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        descLabel.anchor(top: formLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        textField.anchor(top: descLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 30, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        nextButton.anchor(top: textField.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        spinner.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 30, heightConstant: 30)
        spinner.anchorCenterSuperview()
        
        pageControl.anchor(top: nil, leading: nil, trailing: nil, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchorCenterXToSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    func checkInput(_ sender: AnyObject) {
        view.endEditing(true)
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
        checkInput(self)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let text = textFieldText.replacingCharacters(in: range, with: string)
        
        _ = isValidInput(text: text)

        return true
    }
    
}

extension FormViewController: DisplayBanner {
    
}
