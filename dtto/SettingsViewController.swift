//
//  SettingsViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = 50
//        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = true
        
        tv.register(EditUserInfoBaseCell.self, forCellReuseIdentifier: "EditUserInfoBaseCell")

        return tv
    }()
    
    func setupViews() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.done))
        
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavBar()
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "OI")
        cell.textLabel?.text = "Hello"
        cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "check"))
        return cell
    }
}
