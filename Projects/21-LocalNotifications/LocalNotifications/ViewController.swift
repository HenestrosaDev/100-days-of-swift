//
//  ViewController.swift
//  LocalNotifications
//
//  Created by JC on 17/9/21.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var willAppearTomorrow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Register",
            style: .plain,
            target: self,
            action: #selector(registerLocal)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Schedule",
            style: .plain,
            target: self,
            action: #selector(scheduleLocal)
        )
    }
    
    // Requests permission to show notifications on the locker screen
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        // options: Shows alert, badge and plays a sound
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission NOT granted")
            }
        }
    }
    
    @objc func scheduleLocal() {
        // This will allow iOS to know what the "alarm" category does
        registerAlarmCategory()
        
        let center = UNUserNotificationCenter.current()
        /* In case that we want to remove notifications scheduled to appear in the future
        center.removeAllPendingNotificationRequests()*/
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Late wake up call"
        notificationContent.body = "The early bird catches the worm, but the second mouse hets the cheese"
        /**
         Custom actions that we assign to the notifications categories. Better off creating an enum.
         It's like setting a notif. channel in Android
         */
        notificationContent.categoryIdentifier = "alarm"
        
        // Custom data with whatever we want to put. It's like putting an extra in an Intent in Android.
        notificationContent.userInfo = ["customData": "fizzbuzz"]
        
        notificationContent.sound = .default
        
        let trigger: UNTimeIntervalNotificationTrigger!
        
        // Challenge 2 of instructor
        if willAppearTomorrow {
            print("willAppearTomorrow")
            /* If we want to repeat it with a fixed time
             var dateComponents = DateComponents()
            dateComponents.hour = 10
            dateComponents.minute = 30
            
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
             */
            
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        } else {
            // Triggers the notification within 5 seconds
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
        
        // Creates the notification
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger
        )
        center.add(request)
        
        willAppearTomorrow = false
    }
    
    func registerAlarmCategory() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // When tapping on the notif. action, the app will be launched right away
        let show = UNNotificationAction(
            identifier: "show",
            title: "Tell me more",
            options: .foreground
        )
        
        // Challenge 2 of instructor
        let reminder = UNNotificationAction(
            identifier: "reminder",
            title: "Remind me in a day",
            options: .foreground
        )
        
        /**
         intentIdentifiers is used to connect the notifications to intents.
         options allows us, for example, to allow carplay support.
         */
        let category = UNNotificationCategory(
            identifier: "alarm",
            actions: [show, reminder],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([category])
    }

    // This method gets executed when a notification or one of its actions is tapped
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data receiver: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                showAlertController(title: "Default identifier", message: "yes")
                
            case "show":
                // The user pressed the "show" action
                showAlertController(title: "show", message: "Show more information")
                
            case "reminder":
                // The user pressed the "show" action
                showAlertController(title: "reminder", message: "Remind me in a day")
                willAppearTomorrow = true
                scheduleLocal()
                
            default:
                break
            }
        }
        
        // Runs the closure defined above when we tap on a notification
        completionHandler()
    }
    
    // Challenge 1 of instructor
    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

