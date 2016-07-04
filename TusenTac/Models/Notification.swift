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
        
        return !(currentNotificationSettings?.types == UIUserNotificationType.None)
    }
    
    func doSendNotifications() -> Bool {
        return isNotificationsEnabled() && UserDefaults.boolForKey(UserDefaultKey.NotificationsEnabled)
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
            snoozeAction.title = "Slumre \(Notifications.snoozeDelayInMinutes) min"
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
    
    /*func decrementIconBadgeNumber(notificationTime: NSDate?, taskCompleted: Bool){
        //for decrementing notification counter on icon
        if (UIApplication.sharedApplication().applicationIconBadgeNumber > 0) {
            if(notificationTime?.isLessThanDate(NSDate) && taskCompleted){
                         UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
            }
         }
        
        UserDefaults.setBool(false, forKey: task)
    }*/
    
    func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func cancelNotifications(withType: String) {
        let notifyArray = UIApplication.sharedApplication().scheduledLocalNotifications
        for notifyCancel in notifyArray! {
            if notifyCancel.userInfo![UserDefaultKey.notificationType] as! String == withType {
                UIApplication.sharedApplication().cancelLocalNotification(notifyCancel)
            }
        }
    }
    
    func scheduleWeightNotification() {
        cancelNotifications(UserDefaultKey.weightRegistration)
        if !(doSendNotifications() && UserDefaults.boolForKey(UserDefaultKey.weightSwitchOn)) { return }
    
        let nextWeightRegistrationTime = NSCalendar.currentCalendar().dateByAddingUnit(
            Notifications.weightTimeUnit, value: Notifications.weightTimeValue, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))!
        scheduleNotification(nextWeightRegistrationTime, hasSent: UserDefaultKey.hasSendtWeightNotification, userInfo: [
            UserDefaultKey.notificationType: UserDefaultKey.weightRegistration,
            UserDefaultKey.timeOfDay: UserDefaultKey.weightTime, ])
    }
    
    func scheduleMedicineNotifications(morning: NSDate? = nil, evening: NSDate? = nil) {
        cancelNotifications(UserDefaultKey.medicineRegistration)
        if !doSendNotifications() { return }
        
        if morning != nil && UserDefaults.boolForKey(UserDefaultKey.morningSwitchOn) {
            scheduleNotification(morning!, repeatInterval: NSCalendarUnit.Day, hasSent: UserDefaultKey.hasSendtMorningNotification, userInfo: [
                UserDefaultKey.notificationType: UserDefaultKey.medicineRegistration,
                UserDefaultKey.timeOfDay: UserDefaultKey.morningTime,
                UserDefaultKey.dosage: UserDefaults.objectForKey(UserDefaultKey.morningDosage)! ])
        }
        
        if evening != nil && UserDefaults.boolForKey(UserDefaultKey.nightSwitchOn) {
            scheduleNotification(evening!, repeatInterval: NSCalendarUnit.Day, hasSent: UserDefaultKey.hasSendtNightNotification, userInfo: [
                UserDefaultKey.notificationType: UserDefaultKey.medicineRegistration,
                UserDefaultKey.timeOfDay: UserDefaultKey.nightTime,
                UserDefaultKey.dosage: UserDefaults.objectForKey(UserDefaultKey.nightDosage)! ])
        }
    }

    func scheduleNotification(fireDate: NSDate, repeatInterval: NSCalendarUnit? = nil, hasSent: String, userInfo: [NSObject: AnyObject]) {
        let notification = UILocalNotification()
        
        notification.fireDate = fireDate
        notification.userInfo = userInfo
        if let optionalRepeatInterval = repeatInterval {
            notification.repeatInterval = optionalRepeatInterval
        }
        
        // Default settings.
        notification.alertBody = Notifications.alertBody
        notification.category = "NOTIFICATION_CATEGORY"
        notification.applicationIconBadgeNumber += 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        UserDefaults.setBool(true, forKey: hasSent)
    }
    
    func getDefaultDates() -> [NSDate] {
        let calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        
        let morning = calendar.dateBySettingHour(9, minute: 0, second: 0, ofDate: today, options: NSCalendarOptions())!
        let evening = calendar.dateBySettingHour(21, minute: 0, second: 0, ofDate: today, options: NSCalendarOptions())!
        
        return [morning, evening]
    }
}
