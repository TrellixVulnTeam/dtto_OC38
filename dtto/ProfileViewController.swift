//
//  ProfileViewController.swift
//  dtto
//
//  Created by Jitae Kim on 12/26/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    
//    init?(user: User) {
//        super.init(nibName: nil, bundle: nil)
//        self.user = user
//        self.title = user.name ?? "Anonymous"
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        tableView.register(UINib(nibName: "ProfileExpertiseCell", bundle: nil), forCellReuseIdentifier: "ProfileExpertiseCell")
        tableView.register(UINib(nibName: "ProfileSummaryCell", bundle: nil), forCellReuseIdentifier: "ProfileSummaryCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            cell.endorse.text = "17 people found Jae helpful."
            cell.name.text = "Jae, 24"
            return cell
            
        case .Education:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "BasicInfoCell")
            cell.imageView?.image = #imageLiteral(resourceName: "education")
            cell.textLabel?.text = "UCLA"
            return cell
            
        case .Profession:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "BasicInfoCell")
            cell.imageView?.image = #imageLiteral(resourceName: "education")
            cell.textLabel?.text = "Financial Analyst"
            return cell
            
        case .Expertise:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileExpertiseCell") as! ProfileExpertiseCell
    
            return cell
            
        case .Summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSummaryCell") as! ProfileSummaryCell
            
            return cell
        }
        return UITableViewCell()
        
        
    }
}
