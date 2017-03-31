//
//  UserInfoPickerViewController.swift
//  dtto
//
//  Created by Jitae Kim on 2/24/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

enum UserInfoType {
    case education
    case profession
    case expertise
}

class UserInfoPickerViewController: UIViewController {

    weak var mainEditDelegate: ProfileEditViewController?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    var userInfoType: UserInfoType
    
    init(_ userInfoType: UserInfoType) {
        self.userInfoType = userInfoType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar(title: "")
        setupPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(textField)
        
        textField.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func setupPlaceHolder() {
        switch userInfoType {
        case .education:
            textField.placeholder = "Add a school"
        case .profession:
            textField.placeholder = "Add a profession"
        case .expertise:
            textField.placeholder = "Add an expertise"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = textField.becomeFirstResponder()
    }
    
}

extension UserInfoPickerViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let text = textFieldText.replacingCharacters(in: range, with: string)
        
        if text.characters.count > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = Color.darkNavy
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = Color.lightGray
        }
        
        return true
    }
    
}

extension UserInfoPickerViewController: FormNavigationBar {
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        guard let text = textField.text, text != "" else { return }
        mainEditDelegate?.addTableViewCell(infoType: userInfoType, placeName: text)
        
        dismiss(animated: true, completion: nil)
    }
}
