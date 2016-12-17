//
//  HomePageViewController.swift
//  Bounce
//
//  Created by Jitae Kim on 12/16/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var pageView = UIPageViewController()
    let descs = ["종류별로 아르카나 검색.", "어빌리티별로 아르카나 검색.", "아르카나 정보 수정."]
    var currentIndex: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.gray247
        setupPageView()
        setupHorizontalBar()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        if let viewController = getViewController(index: currentIndex ?? 1) {
        
            let viewControllers = [viewController]
            
                pageView.setViewControllers(
                    viewControllers,
                    direction: .forward,
                    animated: false,
                    completion: nil
                )
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    var horizontalBarLeadingAnchorConstraint: NSLayoutConstraint?
    var horizontalBarWidthConstraint: NSLayoutConstraint?

    
    func setupHorizontalBar() {
        
        guard let nav = self.navigationController else { return }
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.darkNavy
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        nav.view.addSubview(horizontalBarView)
        
        horizontalBarLeadingAnchorConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: nav.view.leadingAnchor)
        //        horizontalBarLeadingAnchorConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: nav.view.leadingAnchor, constant: 10)
        horizontalBarLeadingAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: nav.navigationBar.bottomAnchor).isActive = true
        
        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: 50)
        horizontalBarWidthConstraint?.isActive = true
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    func setupPageView() {
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageView.dataSource = self
        
        self.addChildViewController(pageView)
        self.view.addSubview(pageView.view)
        
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        pageView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageView.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        pageView.view.backgroundColor = .yellow
    }
    
    func getViewController(index: Int) -> UIViewController? {

        switch index {
            
        case 0:
            
            let notificationsView = NotificationsPage()
            return notificationsView
        case 1:
            
            let homeView = UINavigationController(rootViewController: Home())
            return homeView
        default:
            
            let chat = ChatList()
            return chat
            
        }

        return nil
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension HomePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        
        
    }
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? NotificationsPage {

            return nil
            
        }
        
        else if let viewController = viewController as? UINavigationController {
            
            return getViewController(index: 0)
        }
        
        else if let viewController = viewController as? ChatList {
            
            return getViewController(index: 1)
        }
        
        
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let viewController = viewController as? NotificationsPage {
            
            return getViewController(index: 1)
            
        }
            
        else if let viewController = viewController as? UINavigationController {
            
            return getViewController(index: 2)
        }
            
        else if let viewController = viewController as? ChatList {
            
            return nil
        }
        
        return nil
    }
    
}

