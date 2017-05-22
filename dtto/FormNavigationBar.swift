//
//  FormNavigationBar.swift
//  dtto
//
//  Created by Jitae Kim on 1/21/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Foundation

@objc protocol FormNavigationBar: class {
    
    func save()
    func cancel()
}

extension FormNavigationBar where Self: UIViewController {
    
    func setupNavBar(title: String) {
        
        navigationItem.title = title
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        saveButton.tintColor = .lightGray
        saveButton.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
}
