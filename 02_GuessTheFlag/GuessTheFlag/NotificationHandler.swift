//
//  NotificationHandler.swift
//  GuessTheFlag
//
//  Created by JC on 17/9/21.
//

import UIKit
import UserNotifications

// (Day 73) Challenge of instructor
class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    static let instance = NotificationHandler()

    func askForPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("ok")
            } else {
                print("no")
            }
        }
    }
    
    func scheduleAlerts() {
        registerAlarmCategory()
        print("buenas")
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Want to practice a little?"
        notificationContent.body = "Keeping a habit will make you learn all the flags in no time"
        notificationContent.categoryIdentifier = "alarm"
        notificationContent.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 46
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Creates the notification
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        center.add(request)
    }
    
    private func registerAlarmCategory() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // When tapping on the notif. action, the app will be launched right away
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }

    // When a notification or one of its actions is tappedthis method gets executed
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        scheduleAlerts()
        completionHandler()
    }
}
