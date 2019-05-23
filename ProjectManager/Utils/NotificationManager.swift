//
//  NotificationManager.swift
//  ProjectManager
//
//  Created by Suwadith Srithar on 5/23/19.
//  Copyright © 2019 sk. All rights reserved.
//

import UIKit
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    
    // MARK: Shared Instance
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: Local Notification Methods Starts here
    // Prepare New Notificaion with deatils and trigger
    func scheduleNotification(notificationType: String) {
        
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        content.sound = UNNotificationSound.default
        content.body = "This is example how to send " + notificationType
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        //Add attachment for Notification with more content
        if (notificationType == "Local Notification with Content") {
            let imageName = "Apple"
            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
            let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        //Add Action button the Notification
        if (notificationType == "Local Notification with Action") {
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            notificationCenter.setNotificationCategories([category])
        }
    }
    
    func scheduleNotificationFor(task: Task) {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Task"
        content.sound = UNNotificationSound.default
        content.body = "Due date for the task \(task.name!) is passed"
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        // let imageName = "Apple"
        // guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        // let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        // content.attachments = [attachment]
        
        // var components = DateComponents()
        // components.day = 0
        // components.hour = 8
        // components.minute = 15
        // components.second = 0
        // components.timeZone = TimeZone.current
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate!)
        components.timeZone = TimeZone.current
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let identifier = String(describing: task.objectID)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    //Handle Notification Center Delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        completionHandler()
    }
}
