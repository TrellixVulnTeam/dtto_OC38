//
//  GlobalConstants.swift
//  Bounce
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

var SCREENORIENTATION: UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}

var SCREENWIDTH: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.width
    } else {
        return UIScreen.main.bounds.size.height
    }
}
var SCREENHEIGHT: CGFloat {
    if UIInterfaceOrientationIsPortrait(SCREENORIENTATION) {
        return UIScreen.main.bounds.size.height
    } else {
        return UIScreen.main.bounds.size.width
    }
}

enum Color {
    
    static let salmon = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0) // #EBA5A0
    static let darkSalmon = UIColor(red:0.82, green:0.24, blue:0.32, alpha:1.0)
    static let lightGray = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)
    static let lightGreen = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0) 
    static let textGray = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)
    static let gray247 = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)    // #f7f7f7
    static let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
    static let darkNavy = UIColor(red:0.18, green:0.22, blue:0.29, alpha:1.0) //#2D394B
}
