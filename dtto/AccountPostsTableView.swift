//
//  AccountPostsTableView.swift
//  dtto
//
//  Created by Jitae Kim on 1/6/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class AccountPostsTableView: BaseCollectionViewCell {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 500
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = true
//        tv.contentInset = .init(top: 200, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: SCREENHEIGHT)
    }

}

extension AccountPostsTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = "PLACEHOLDER"
        cell.backgroundColor = .red
        return cell
    }
    
}
