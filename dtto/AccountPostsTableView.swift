//
//  AccountPostsTableView.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AccountPostsTableView: BaseCollectionViewCell {

    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension AccountPostsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = "PLACEHOLDER"
        cell.backgroundColor = .red
        return cell
    }
    
}
