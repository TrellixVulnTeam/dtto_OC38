//
//  ChangeRootVC.swift
//  Chain
//
//  Created by Jitae Kim on 10/19/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum RootVC {
        case login
        case logout
    }
    
    func changeRootVC(vc: RootVC) {
        
        if vc == RootVC.login {
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
            
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            let initialViewController = MyTabBarController()
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: {
                    (value: Bool) in
                    snapshot.removeFromSuperview()
                
            })

        }
        else {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")
            
            let snapshot:UIView = (self.view.window?.snapshotView(afterScreenUpdates: true))!
            initialViewController.view.addSubview(snapshot)
            
            self.view.window?.rootViewController = initialViewController
            
            UIView.animate(withDuration: 0.2, animations: {()  in
                
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                }, completion: {
                    (value: Bool) in
                    snapshot.removeFromSuperview()
                    
            })

        }
        
    }
    
}
