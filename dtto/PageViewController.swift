//
//  PageViewController.swift
//  dtto
//
//  Created by Jitae Kim on 4/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    lazy var viewControllerList: [UIViewController] = {
        
        let notificationsVC = NotificationsViewController()
        notificationsVC.masterViewDelegate = self
        
//        let postsVC = PostViewController()
//        postsVC.masterViewDelegate = self
        
        let chatsVC = ChatListViewController()
        chatsVC.masterViewDelegate = self
        
//        return [notificationsVC, postsVC, chatsVC]
        return [notificationsVC, chatsVC]
        
    }()
    
    var horizontalBarView = UIView()
    var sliderBarCenterXAnchorConstraint: NSLayoutConstraint?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHorizontalBar()
        dataSource = self
        if let firstVC = viewControllerList.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
    }
    
    func setupHorizontalBar() {
        
        let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = self
        
        guard let nav = navigationController else { return }
        horizontalBarView = UIView()
        horizontalBarView.backgroundColor = Color.darkNavy
        
        nav.view.addSubview(horizontalBarView)
        
        horizontalBarView.anchor(top: nil, leading: nil, trailing: nil, bottom: nav.navigationBar.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 1)
        
        sliderBarCenterXAnchorConstraint = horizontalBarView.centerXAnchor.constraint(equalTo: nav.view.leadingAnchor)
        sliderBarCenterXAnchorConstraint?.isActive = true

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0, viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex, viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
        
    }
    
}

