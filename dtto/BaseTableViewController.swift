//
//  BaseTableViewController.swift
//  dtto
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {
    
    weak var masterViewDelegate: PageViewController?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .none

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
}
