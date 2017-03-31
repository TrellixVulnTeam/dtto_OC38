//
//  TabBarController.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Tab: Int {
        case home
        case post
        case profile
    }
    
    var tabBarImageView: UIImageView!
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBar()
        tabBar.tintColor = Color.darkNavy
        view.backgroundColor = .white
    }
    
    func setupTabBar() {
        
        let homeTab = UINavigationController(rootViewController: MasterCollectionView())
        homeTab.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home"), tag: 0)
        homeTab.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)

        let postTab = UINavigationController(rootViewController: ComposePostViewController())
        postTab.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "plus"), tag: 1)
        postTab.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        let profileTab = UINavigationController(rootViewController: ProfileViewController())
        profileTab.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "userTab"), tag: 2)
        profileTab.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [homeTab, postTab, profileTab]
        
        // Setup to-be-animated views
        for childView in tabBar.subviews {
            
            let tabBarItemView = childView
            tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)
            
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        imageViews[item.tag].bounceAnimate()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // TODO: Find better way of identifying tab
        if viewController.childViewControllers[0] is ComposePostViewController {
            let navController = UINavigationController(rootViewController: ComposePostViewController())
            tabBarController.present(navController, animated: true)
            return false
        }
        else {
            return true
        }

    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC.childViewControllers[0] is ComposePostViewController {
            let navController = UINavigationController(rootViewController: ComposePostViewController())
            tabBarController.present(navController, animated: true)
            return nil
        }
        else {
            return TransitioningObject()
        }
        
        
    }
    
    
}
