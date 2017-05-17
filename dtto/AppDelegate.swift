
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
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Configure Firebase
        
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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        if let _ = defaults.getUID() {
            let initialViewController = TabBarController()
//            let initialViewController = NavigationController(PostViewController(postID: "-KjKPM6BjTJm4resxqNe"))
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

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("opening url...")
        if url.scheme == "dtto" {
            // TODO: Handle different types of URLS. For now, only posts will be linked.
            
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
            USERS_REF.child(userID).child("notificationTokens").child(refreshedToken).setValue(true)
            
        }
    
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    private enum NotificationType: String {
        case request
        case message
        case endorse
        case relate
        case comment
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
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        
        // for each notification, check if the user was already in the proper screen.
        let userInfo = response.notification.request.content.userInfo
        if let type = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: type) {

            if let tabBarController = window?.rootViewController as? TabBarController, let navVC = tabBarController.childViewControllers[0] as? UINavigationController, let cv = navVC.childViewControllers[0] as? MasterCollectionView {
                
                    switch notificationType {
                        
                    case .relate, .comment:
                        guard let postID = userInfo["postID"] as? String else { return }
                        if let postVC = UIApplication.topViewController() as? CommentsViewController {
                            if postVC.post.getPostID() == postID {
                                return
                            }
                        }
                        let vc = PostViewController(postID)
                        navVC.pushViewController(vc, animated: true)
                        
                    case .request:
                        if UIApplication.topViewController() as? RequestsViewController == nil {
                            let requestsVC = RequestsViewController()
                            navVC.pushViewController(requestsVC, animated: true)
                        }
                        
                    case .message, .endorse:
                        cv.scrollToMenuIndex(cv.chatButton)
                        
                        guard let chatID = userInfo["chatID"] as? String else { return }
                        
                        if let chatVC = UIApplication.topViewController() as? MessagesViewController {
                            if chatVC.chat.getChatID() == chatID {
                                return
                            }
                        }
                        else if let chatListVC = cv.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? ChatList {
                            for (index, chat) in chatListVC.chats.enumerated() {
                                if chat.getChatID() == chatID {
                                    chatListVC.tableView(chatListVC.tableView, didSelectRowAt: IndexPath(row: index, section: 1))
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

func getTopViewController() -> UIViewController {
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
        // topController should now be your topmost view controller
    }
    return UIViewController()
}


extension AppDelegate {
    
    func requestNotifications() {
        
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
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                
                if settings.authorizationStatus != .authorized && defaults.getShowedNotification() {
                    print("Push not authorized")
                    getTopViewController().promptSettings()
                }
                
                defaults.setShowedNotification(value: true)

            }

        } else {
            // Fallback on earlier versions
            
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            if notificationType == [] && defaults.getShowedNotification() {
                print("notifications are NOT enabled")
                getTopViewController().promptSettings()
            }
            
            defaults.setShowedNotification(value: true)

        }
        

        // [END register_for_notifications]
    }
}

extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            let top = topViewController(nav.visibleViewController)
            return top
        }
        
        if let tab = base as? UITabBarController
        {
            if let selected = tab.selectedViewController
            {
                let top = topViewController(selected)
                return top
            }
        }
        
        if let presented = base?.presentedViewController
        {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}
