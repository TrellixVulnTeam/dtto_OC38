//
//  ProfileViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var user: User?
    
    lazy var tableView: UITableView = {

        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        
        tv.estimatedRowHeight = 50
        tv.estimatedSectionHeaderHeight = 20
        tv.separatorInset = .zero
        tv.layoutMargins = .zero
        
        tv.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "ProfileImageCell")
        tv.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        tv.register(UINib(nibName: "ProfileExpertiseCell", bundle: nil), forCellReuseIdentifier: "ProfileExpertiseCell")
        tv.register(UINib(nibName: "ProfileSummaryCell", bundle: nil), forCellReuseIdentifier: "ProfileSummaryCell")
        return tv
    }()
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
        self.title = user.displayName ?? "Anonymous"
        print("TITLE IS \(title!)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))

        self.navigationItem.rightBarButtonItem = logoutButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        setupViews()
    }


    func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
//            if let education = user.education {
//                return education.count
//            }
//            else {
//                return 0
//            }
            return 1
            
        case .Profession:
            //            if let profession = user.profession {
            //                return 1
            //            }
            //            else {
            //                return 0
            //            }
            return 1
            
        case .Expertise:
            // if let _ = user.expertise return 1
            return 1
            
        case .Summary:
            // return user.summary ?? 0
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .Education, .Profession, .Expertise:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .Education:
            return ProfileSectionHeader(sectionTitle: "Education")
        case .Profession:
            return ProfileSectionHeader(sectionTitle: "Profession")
        case .Expertise:
            return ProfileSectionHeader(sectionTitle: "Expertise")
        default:
            return nil
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            cell.endorses.text = "17 people found Jae helpful."
            cell.name.text = "Jae, 24"
            cell.profileImage.image = #imageLiteral(resourceName: "profile")
            return cell
            
        case .Education:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.icon.image = #imageLiteral(resourceName: "education")
            cell.titleLabel.text = "UCLA"
            return cell
            
        case .Profession:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            cell.icon.image = #imageLiteral(resourceName: "suitcase")
            cell.titleLabel.text = "Financial Analyst"
            return cell
            
        case .Expertise:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExpertiseCell") as! ProfileExpertiseCell
            cell.icon.image = #imageLiteral(resourceName: "relate")
            cell.tagsLabel.text = "Some tags here Some tags here Some tags here Some tags here"
            return cell
            
        case .Summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSummaryCell") as! ProfileSummaryCell
            
            return cell
        }
        
        
    }
}
