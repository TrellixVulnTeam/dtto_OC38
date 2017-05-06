//
//  TableViewExtensions.swift
//  dtto
//
//  Created by Jitae Kim on 5/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

extension UITableView {
    
    func insertIndexPathAt(index: Int) {
        beginUpdates()
        insertSections(IndexSet(integer: index), with: .automatic)
        endUpdates()
    }

    func deleteIndexPathAt(index: Int) {
        beginUpdates()
        deleteSections(IndexSet(integer: index), with: .automatic)
        endUpdates()
    }
    
}
