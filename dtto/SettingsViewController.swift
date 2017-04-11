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
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")

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
        title = "Settings"
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func confirmLogout() {
        let alertController = UIAlertController(title: "Logout",
                                                message: "Do you want to logout?",
                                                preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            self.logout()
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
        
        guard let indexPath = tableView.indexPath(for: cell), let row = Notification(rawValue: indexPath.row), let userID = defaults.getUID() else { return }
        
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
    
    fileprivate enum Notification: Int {
        case push
        case email
    }
    
    private enum Section: Int {
        case notifications
        case account
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .notifications:
            return 2
        case .account:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .notifications:
            return "Notifications"
        case .account:
            return "Account"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .notifications:
            guard let row = Notification(rawValue: indexPath.row) else { return UITableViewCell() }
            
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

        case .account:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = "Logout"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        guard let section = Section(rawValue: indexPath.section) else { return false }
        
        switch section {
        case .notifications:
            return false
        case .account:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        if section == .account {
            confirmLogout()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
