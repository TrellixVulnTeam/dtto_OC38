//
//  SortDictionary.swift
//  dtto
//
//  Created by Jitae Kim on 1/5/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation


func sortByValue(dict: [String : Int]) -> [String] {
    var array = Array(dict.keys)
    array.sort {
        return dict[$0]! < dict[$1]!
    }
    
    return array
}
