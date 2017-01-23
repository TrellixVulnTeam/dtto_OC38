//
//  DatePickerViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/21/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class DatePickerViewController: UIViewController, FormNavigationBar {

    weak var mainEditDelegate: ProfileEditViewController?
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let currentDate = Date()
        datePicker.maximumDate = currentDate
        return datePicker
    }()
    
    lazy var removeBirthdayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove birthday", for: UIControlState())
        button.tintColor = .red
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(removeBirthday), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(datePicker)
        view.addSubview(removeBirthdayButton)
        
        datePicker.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 200)
        
        removeBirthdayButton.anchor(top: datePicker.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
    }

    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        mainEditDelegate?.updateBirthday(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }

    func removeBirthday() {
        mainEditDelegate?.updateBirthday(date: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavBar(title: "Edit birthday")
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = Color.darkNavy

    }

}
