//
//  AlertExtensions.swift
//  dtto
//
//  Created by Jitae Kim on 5/9/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

private let NOTIFICATIONS_TITLE = "Turn on notifications?"
private let NOTIFICATIONS_MESSAGE = "You will be notified when someone wants to talk with you."

private let PREVIOUSLYDECLINED_TITLE = "Wait!"
private let PREVIOUSLYDECLINED_MESSAGE = "It seems that you previously declined notifications. To allow them, you need to go to your settings and enable notifications for dtto."

extension UIViewController {
    
    func askNotifications() {
        
        // TODO: Analytics.
        let ac = UIAlertController(title: NOTIFICATIONS_TITLE, message: NOTIFICATIONS_MESSAGE, preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        ac.addAction(cancelAction)
        
        let allowAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.requestNotifications()
        })
        
        ac.addAction(allowAction)
        
        present(ac, animated: true, completion: nil)

    }
    
    func promptSettings() {
        
        let ac = UIAlertController(title: PREVIOUSLYDECLINED_TITLE, message: PREVIOUSLYDECLINED_MESSAGE, preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        ac.addAction(cancelAction)
        
        let allowAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            guard let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.openURL(appSettings as URL)
        })
        
        ac.addAction(allowAction)
        
        present(ac, animated: true, completion: nil)

    }
    
}
