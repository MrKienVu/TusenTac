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
    
    func scheduleLocalNotification(date: NSDate) {
        let localNotification = UILocalNotification()
        let fireDate = fixNotificationDate(date)
        localNotification.fireDate = fireDate
        localNotification.alertBody = "Du har en ny oppgave å gjøre."
        localNotification.alertAction = "Vise valg"
        localNotification.category = "NOTIFICATION_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        print("Scheduled local notification at firedate: \(fireDate)")
    }
    
    private func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        
        let currentDate = NSDate()
        let currentDateComponents = calendar.components([.Year, .Month, .Day], fromDate: currentDate)
        
        let otherDateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: dateToFix)
        otherDateComponents.year = currentDateComponents.year
        otherDateComponents.month = currentDateComponents.month
        otherDateComponents.day = currentDateComponents.day
        
        let fixedDate = calendar.dateFromComponents(otherDateComponents)
        
        return fixedDate!
    }
}
