//
//  TabBarController.swift
//  Bounce
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
//    let tabTitles = ["Home", "Messages"]
    let tabIcons = [#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "plus"), #imageLiteral(resourceName: "user")]
//    let storyboards = ["Main", "Ability", "Tavern", "Settings"]
//    let childVCs = ["HomeNav", "AbilityNav", "TavernNav", "FavoritesNav"]
    
    var tabBarImageView: UIImageView!
    var imageViews = [UIImageView]()
    override func viewDidLoad() {
        
        self.delegate = self
        setupTabBar()
        self.tabBar.tintColor = Color.darkNavy
        
    }
    
    func setupTabBar() {
        
        var views = [UIViewController]()
        // Setup Tab Bar Views
        
        for (index, tab) in tabIcons.enumerated() {

            switch index {
                
            case 0:
                
//                let child = NavigationController()
                let child = UINavigationController(rootViewController: CollectionViewWithMenu())
//                let child = UINavigationController(rootViewController: HomePageViewController())
//                child.isNavigationBarHidden = true
                child.tabBarItem.title = ""
                child.tabBarItem.image = tab
                child.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
                child.tabBarItem.tag = index
                views.append(child)
                
            case 1:
                
//                let currentStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let child = UIViewController()//currentStoryboard.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                
                child.tabBarItem.title = ""
                child.tabBarItem.image = tab
                child.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
                child.tabBarItem.tag = index
                views.append(child)
                
                
            default:
                
                let vc = ChatList()
                let child = UINavigationController(rootViewController: vc)
                
                child.tabBarItem.title = ""
                child.tabBarItem.image = tab
                child.tabBarItem.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
                child.tabBarItem.tag = index
                views.append(child)
                
                
            }
            

                
//            default:
//                let currentStoryboard = UIStoryboard(name: storyboards[index], bundle:nil)
//                let child = currentStoryboard.instantiateViewController(withIdentifier: childVCs[index]) as! UINavigationController
//                
//                child.tabBarItem.title = tab
//                child.tabBarItem.image = tabIcons[index]
//                child.tabBarItem.tag = index
//                views.append(child)
                
                
            
            
        }
        
        self.viewControllers = views
        
        // Setup to-be-animated views
        for childView in tabBar.subviews {
            
            let tabBarItemView = childView
            self.tabBarImageView = tabBarItemView.subviews.first as! UIImageView
            self.tabBarImageView.contentMode = .center
            imageViews.append(tabBarImageView)
            
        }
        
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        imageViews[item.tag].bounceAnimate()
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningObject()
        
    }
    
    
}
