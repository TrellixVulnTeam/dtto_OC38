//
//  SettingsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsProtocol : class {
    func toggleNotifications(cell: SettingsToggleCell)
}

class SettingsViewController: UIViewController, SettingsProtocol {

    var pushEnabled = false {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    var initialLoad = true
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = 90

        tv.showsVerticalScrollIndicator = true
        
        tv.register(SettingsToggleCell.self, forCellReuseIdentifier: "SettingsToggleCell")

        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationSettings), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if initialLoad {
            initialLoad = false
        }
        checkNotificationSettings()

    }
    
    func setupViews() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.done))
        
        navigationItem.rightBarButtonItem = doneButton
        
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func logout() {
        defaults.setValue(nil, forKey: "uid")
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        changeRootVC(vc: .logout)
    }

    func checkNotificationSettings() {
        
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        
        if notificationType == [] {
            pushEnabled = false
        }
        else {
            pushEnabled = true
        }
    }

    func showNotificationsDisabledAlert() {
        let alertController = UIAlertController(title: "Turn on notifications?",
                                                message: "To get notifications from dtto, turn them on in your Settings.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.checkNotificationSettings()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func toggleNotifications(cell: SettingsToggleCell) {
        
        guard let indexPath = tableView.indexPath(for: cell), let row = Row(rawValue: indexPath.row), let userID = defaults.getUID() else { return }
        
        switch row {
        case .push:
            
            if cell.toggle.isOn {
                showNotificationsDisabledAlert()
            }
            
        case .email:
            
            let emailRef = USERS_REF.child(userID).child("receiveEmails")
            if cell.toggle.isOn {
                emailRef.setValue(true)
            }
            else {
                emailRef.setValue(false)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate enum Row: Int {
        case push
        case email
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notifications"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsToggleCell") as! SettingsToggleCell
        cell.settingsDelegate = self
        
        switch row {
        case .push:
            cell.titleLabel.text = "Push"
            cell.toggle.isOn = pushEnabled
        case .email:
            cell.titleLabel.text = "Email"
        }
        
        return cell
    }
}
