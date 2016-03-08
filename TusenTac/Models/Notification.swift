//
//  Notification.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 06/01/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class Notification {
    static let sharedInstance = Notification()
    
    func isNotificationsEnabled() -> Bool {
        let currentNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if currentNotificationSettings?.types == UIUserNotificationType.None {
            return false
        }
        
        return true
    }
    
    func setupNotificationSettings() {
        if !isNotificationsEnabled() {
            let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
            
            
            // Specify notification actions
            let goAction = UIMutableUserNotificationAction()
            goAction.identifier = "GO_ACTION"
            goAction.title = "Gå til app"
            goAction.activationMode = UIUserNotificationActivationMode.Foreground
            goAction.destructive = false
            goAction.authenticationRequired = true
            
            let snoozeAction = UIMutableUserNotificationAction()
            snoozeAction.identifier = "SNOOZE_ACTION"
            snoozeAction.title = "Slumre 30 min"
            snoozeAction.activationMode = UIUserNotificationActivationMode.Background
            snoozeAction.destructive = false
            snoozeAction.authenticationRequired = false
            
            let actionsArray = NSArray(objects: goAction, snoozeAction) as! [UIUserNotificationAction]
            
            // Specify the category related to the above actions
            let category = UIMutableUserNotificationCategory()
            category.identifier = "NOTIFICATION_CATEGORY"
            category.setActions(actionsArray, forContext: UIUserNotificationActionContext.Minimal)
            
            let categoriesForSettings = NSSet(objects: category)
            let notificationSettings = UIUserNotificationSettings(
                forTypes: notificationTypes,
                categories: categoriesForSettings as? Set<UIUserNotificationCategory>
            )
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func scheduleNotifications(morning: NSDate, evening: NSDate) {
        if !UserDefaults.boolForKey(UserDefaultKey.NotificationsEnabled) { return }
        
        if !isNotificationsEnabled() {
            print("Notification switch on, but notifications not enabled. Not scheduling notifications.")
            return
        }
        
        cancelAllNotifications()
        
        let morningNotification = UILocalNotification()
        morningNotification.fireDate = morning
        morningNotification.alertBody = "Du har en ny oppgave å gjøre."
        morningNotification.category = "NOTIFICATION_CATEGORY"
        morningNotification.repeatInterval = NSCalendarUnit.Day
        morningNotification.applicationIconBadgeNumber += 1
        morningNotification.userInfo = ["type": "medicineRegistration"]
        UIApplication.sharedApplication().scheduleLocalNotification(morningNotification)
        NSLog("Scheduled morning notifications: \n \(morningNotification)")
        
        let eveningNotification = UILocalNotification()
        eveningNotification.fireDate = evening
        eveningNotification.alertBody = "Du har en ny oppgave å gjøre."
        eveningNotification.category = "NOTIFICATION_CATEGORY"
        eveningNotification.repeatInterval = NSCalendarUnit.Day
        eveningNotification.applicationIconBadgeNumber += 1
        eveningNotification.userInfo = ["type": "medicineRegistration"]
        UIApplication.sharedApplication().scheduleLocalNotification(eveningNotification)
        NSLog("Scheduled evening notifications: \n \(eveningNotification)")
    }
    
    func getDefaultDates() -> [NSDate] {
        let calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        
        let morning = calendar.dateBySettingHour(9, minute: 0, second: 0, ofDate: today, options: NSCalendarOptions())!
        let evening = calendar.dateBySettingHour(21, minute: 0, second: 0, ofDate: today, options: NSCalendarOptions())!
        
        return [morning, evening]
    }
}
