//
//  ProfileViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class ProfileViewController: UIViewController {

    var user: User? {
        didSet {
            navigationItem.title = user?.getName()
        }
    }
    var userID: String?
    
    lazy var tableView: UITableView = {

        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .white
        tv.alpha = 0
        
        tv.estimatedRowHeight = 200
        tv.estimatedSectionHeaderHeight = 20
        tv.separatorInset = .zero
        tv.layoutMargins = .zero
        tv.allowsSelection = false

        tv.register(ProfileImageCell.self, forCellReuseIdentifier: "ProfileImageCell")
        tv.register(ProfileInfoCell.self, forCellReuseIdentifier: "ProfileInfoCell")
        tv.register(ProfileExpertiseCell.self, forCellReuseIdentifier: "ProfileExpertiseCell")
        tv.register(ProfileSummaryCell.self, forCellReuseIdentifier: "ProfileSummaryCell")
        return tv
    }()
    
    let spinner = NVActivityIndicatorView(frame: .zero, type: .ballClipRotate, color: Color.darkNavy, padding: 0)
   
    // Init with current user, or pass another user's ID
    init() {
        userID = defaults.getUID()
        super.init(nibName: nil, bundle: nil)
        setupNavBar()
    }
    
    init(userID: String) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let userID = userID else { return }
        USERS_REF.child(userID).removeAllObservers()
        PROFILES_REF.child(userID).removeAllObservers()
    }
    
    private func setupNavBar() {
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settings))
        
//        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        self.navigationItem.leftBarButtonItem = editButton
        self.navigationItem.rightBarButtonItem = settingsButton
//        self.navigationItem.rightBarButtonItem = logoutButton
        
    }
    
    func edit() {
        guard let user = user else { return }
        present(NavigationController(ProfileEditViewController(user: user)), animated: true, completion: nil)
    }
    
    func settings() {
        present(NavigationController(SettingsViewController()), animated: true, completion: nil)
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
        
        
        self.changeRootVC(vc: .logout)
    }

    func animateSpinner(_ animate: Bool) {
        
        if animate {
            
            view.addSubview(spinner)
            
            spinner.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
            spinner.anchorCenterSuperview()
            
            view.layoutIfNeeded()
            spinner.startAnimating()

        }
        else {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
        
        
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false

        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)

    }
    
    func observeUser() {
        
        guard let userID = userID else { return }
        
        animateSpinner(true)
        
        PROFILES_REF.child(userID).observe(.value, with: { snapshot in
            
            // get the public user profile.
            self.user = User(snapshot: snapshot)
            
            DispatchQueue.main.async {
                self.animateSpinner(false)
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
            
        })
        
        // do stuff if this is the user viewing his own
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case profile
        case about
        case skills
        case interests
        case location
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section), let user = user else { return 0 }
        
        switch section {
            
        case .profile:
            return 1
        case .about:
            return user.education.count
        case .skills:
            return user.profession.count
        case .interests:
            return user.expertise.count
        case .location:
            if let _ = user.location {
                return 1
            }
        }
        return 0

    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if tableView.numberOfRows(inSection: section) != 0 {
            
            guard let section = Section(rawValue: section) else { return 0 }
            
            switch section {
            case .profile:
                return 0
            default:
                return 30
            }
            
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .profile:
            return nil
        case .about:
            return "  What I Do"
        case .skills:
            return "  Skills"
        case .interests:
            return "  Interests"
        case .location:
            return "  Location"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section), let user = user else { return UITableViewCell() }
        
        switch section {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            cell.usernameLabel.text = user.getUsername()
            cell.nameLabel.text = user.getName()
            cell.postsCountLabel.text = String(user.getPostCount())
            cell.relatableCountLabel.text = String(user.getRelatesReceivedCount())
            cell.helpsGivenCountLabel.text = String(user.getHelpfulCount())
            cell.summaryLabel.text = user.getSummary()
            cell.profileImageView.loadProfileImage(user.getUserID())
            return cell
            
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.titleLabel.text = user.education[indexPath.row]
            return cell
            
        case .skills:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.titleLabel.text = user.profession[indexPath.row]
            return cell
            
        case .interests:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExpertiseCell") as! ProfileExpertiseCell
//            cell.icon.image = #imageLiteral(resourceName: "relate")
//            cell.tagsLabel.text = "Some tags here Some tags here Some tags here Some tags here"
            return cell
            
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSummaryCell") as! ProfileSummaryCell
            cell.summaryLabel.text = user.summary!
            return cell
        }
        
        
    }
}
