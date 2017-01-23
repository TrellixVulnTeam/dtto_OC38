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

    var user = User()
    
    lazy var tableView: UITableView = {

        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
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
        super.init(nibName: nil, bundle: nil)
        setupNavBar()
    }
    
    init(userID: String) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func edit() {
        
        present(UINavigationController(rootViewController: ProfileEditViewController(user: self.user)), animated: true, completion: nil)
    }
    
    func settings() {
        present(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
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
    
    private func setupNavBar() {
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settings))

//        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        self.navigationItem.leftBarButtonItem = editButton
        self.navigationItem.rightBarButtonItem = settingsButton
//        self.navigationItem.rightBarButtonItem = logoutButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSpinner(true)
        observeUser()
        setupViews()
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
        
//        guard let user = user else { return }
//        guard let userID = user.uid else { return }
        let testID = "tw2QiARnU7ZFZ7we4tmKs3HcSU42"
        
        let userRef = FIREBASE_REF.child("users").child(testID)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // get all user attributes, then add to tableview
            guard let userSnapshot = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            guard let name = userSnapshot["name"] as? String, let username = userSnapshot["username"] as? String else { return }
            
            let user = User()
            user.name = name
            user.username = username
            self.navigationItem.title = username
            
            if let birthday = userSnapshot["birthday"] as? String {
                user.birthday = birthday
            }
            
            if let education = userSnapshot["education"] as? Dictionary<String, Int> {
                
                user.education = sortByValue(dict: education)
                
            }
            
            if let profession = userSnapshot["profession"] as? Dictionary<String, Int> {
                
                user.profession = sortByValue(dict: profession)
                
            }
            
            if let expertise = userSnapshot["expertise"] as? Dictionary<String, Int> {

                user.expertise = sortByValue(dict: expertise)
                
            }
            
            if let summary = userSnapshot["summary"] as? String {
                user.summary = summary
            }
            
            if let relatesReceivedCount = userSnapshot["relatesReceivedCount"] as? Int {
                user.relatesReceivedCount = relatesReceivedCount
            }
            
            self.user = user
            self.animateSpinner(false)
            self.tableView.alpha = 1
            self.tableView.reloadData()
            
        })
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case Profile
        case Education
        case Profession
        case Expertise
        case Summary
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
            
        case .Profile:
            return 1
        case .Education:
            return user.education.count
        case .Profession:
            return user.profession.count
        case .Expertise:
            return user.expertise.count
        case .Summary:
            if let _ = user.summary {
                return 1
            }
            else {
                return 0
            }
        }

    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if tableView.numberOfRows(inSection: section) != 0 {
            
            guard let section = Section(rawValue: section) else { return 0 }
            
            switch section {
            case .Education, .Profession, .Expertise, .Summary:
                return 30
            default:
                return 0
            }
            
        }
        else {
            return 0
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        

        if tableView.numberOfRows(inSection: section) != 0 {
            return "  Section"
        }
        else {
            return nil
        }
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        guard let section = Section(rawValue: section) else { return nil }
//        
//        switch section {
//        case .Education:
//            return ProfileSectionHeader(sectionTitle: "Education")
//        case .Profession:
//            return ProfileSectionHeader(sectionTitle: "Profession")
//        case .Expertise:
//            return ProfileSectionHeader(sectionTitle: "Expertise")
//        case .Summary:
//            return ProfileSectionHeader(sectionTitle: "Summary")
//        default:
//            return nil
//            
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell

            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            return cell
            
        case .Education:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.icon.image = #imageLiteral(resourceName: "education")
            cell.titleLabel.text = user.education[indexPath.row]
            return cell
            
        case .Profession:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.icon.image = #imageLiteral(resourceName: "suitcase")
            cell.titleLabel.text = user.profession[indexPath.row]
            return cell
            
        case .Expertise:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExpertiseCell") as! ProfileExpertiseCell
//            cell.icon.image = #imageLiteral(resourceName: "relate")
//            cell.tagsLabel.text = "Some tags here Some tags here Some tags here Some tags here"
            return cell
            
        case .Summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSummaryCell") as! ProfileSummaryCell
            cell.summaryLabel.text = user.summary!
            return cell
        }
        
        
    }
}
