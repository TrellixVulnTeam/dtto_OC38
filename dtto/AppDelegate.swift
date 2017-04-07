
//
//  AppDelegate.swift
//  dtto
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Stripe
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Configure Firebase
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        FIRApp.configure()
//        FIRDatabase.database().persistenceEnabled = true

        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]

        // Login Providers
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        // Configure Google Places
        GMSPlacesClient.provideAPIKey("AIzaSyCnPwF0sigqf4nlHoIgu1QRos4nQYgwbH4")
        
        // Configure Stripe
        STPPaymentConfiguration.shared().publishableKey = "pk_test_j23FETJXZSrnbjgBaT3SIeX9"
//        FIRAuth.auth()?.signIn(withEmail: "test@gmail.com", password: "test123") { (user, error) in
//            if error != nil {
//                print("could not login")
//            }
//            else {
//                print("logged in!")
//                
//            }
//        }
        
        // Navigation Bar Setup
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : Color.darkNavy]
        UINavigationBar.appearance().tintColor = Color.darkNavy
        UINavigationBar.appearance().barTintColor = .white
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
//        let initialViewController = TabBarController()
//        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {() -> Void in
//            self.window!.rootViewController = initialViewController
//        }, completion: nil)
//        defaults.setUID(value: "tw2QiARnU7ZFZ7we4tmKs3HcSU42")
//        defaults.setLogin(value: true)
//        defaults.setUID(value: "dueyYrZnhZTYRlAXfL0U9ErcOj02")
//        defaults.setName(value: "Jitae")
//        defaults.setUsername(value: "jk")
        if defaults.isLoggedIn() {
            let initialViewController = TabBarController()
//            UIView.transition(with: self.window!, duration: 0.5, options: .transitionCurlUp, animations: {() -> Void in
                self.window!.rootViewController = initialViewController
//            }, completion: nil)

        } else {
            // No user is signed in.
            let initialViewController = LoginHome()
//            let initialViewController = UINavigationController(rootViewController: UsernameViewController())
//            UIView.transition(with: self.window!, duration: 0.5, options: .transitionCurlUp, animations: {() -> Void in
                self.window!.rootViewController = initialViewController
//            }, completion: nil)
        }
    
 
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
        print("Connected to FCM.")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("opening url...")
        let path = url.absoluteString
        
        if path == "dtto://hi" {
            print("success")
            return true
        }


        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        let googleHandler = GIDSignIn.sharedInstance().handle(url,
                                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        return facebookHandler || googleHandler
    }
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token(), let userID = defaults.getUID() {
            print("InstanceID token: \(refreshedToken)")
            
            // upload the token to user's firebase path
            let userTokenRef = FIREBASE_REF.child("users").child(userID).child("notificationTokens")
            userTokenRef.child(refreshedToken).setValue(true)
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        print("FIRINSTANCE TOKEN IS :" + FIRInstanceID.instanceID().token()!)
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
                
            }
        }
    }
    // [END connect_to_fcm]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    private enum NotificationType: String {
        case request
        case message
    }
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification in foreground")
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let type = userInfo["type"] as? String {
            print(type)
        }
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification in background or closed.")
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let type = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: type) {
            print(type)
            switch notificationType {
            case .request, .message:

                // push requests VC
                if let tabBarController = window?.rootViewController as? TabBarController {
                    if let navVC = tabBarController.childViewControllers[0] as? UINavigationController, let cv = navVC.childViewControllers[0] as? MasterCollectionView {
                        cv.scrollToMenuIndex(cv.chatButton)
                        
                        if notificationType == .request {
                            let requestsVC = RequestsViewController()
                            navVC.pushViewController(requestsVC, animated: true)
                        }
                        else if notificationType == .message {
                            // find the chat and push it.
                            if let chatListVC = cv.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? ChatList {
                                print("UNWRAPPED")
                            }
                            if let chatID = userInfo["chatID"] as? String, let chatListVC = cv.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? ChatList {
                                for (index, chat) in chatListVC.chats.enumerated() {
                                    if chat.getChatID() == chatID {
                                        chatListVC.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]

func getTopViewController()->UIViewController{
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
        // topController should now be your topmost view controller
    }
    return UIViewController()
}
