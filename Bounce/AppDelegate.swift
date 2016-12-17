//
//  AppDelegate.swift
//  Bounce
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Navigation Bar Setup
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : Color.darkNavy]
        UINavigationBar.appearance().tintColor = Color.darkNavy
        UINavigationBar.appearance().barTintColor = .white
        
        // Login Providers
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        let initialViewController = TabBarController()
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
            self.window!.rootViewController = initialViewController
        }, completion: nil)
        
        /*
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let _ = user {
                // User is signed in.
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeNav")
                let initialViewController = TabBarController()
                UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                    self.window!.rootViewController = initialViewController
                }, completion: nil)

            } else {
                // No user is signed in.
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginHome")
                UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
                    self.window!.rootViewController = initialViewController
                }, completion: nil)
            }
        }
        */
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        let googleHandler = GIDSignIn.sharedInstance().handle(url,
                                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        return facebookHandler || googleHandler
    }



}


