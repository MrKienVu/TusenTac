//
//  AppDelegate.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 18/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.tintColor = Color.primaryColor
        
        let hasLaunchedBefore = UserDefaults.boolForKey(UserDefaultKey.hasLaunchedBefore)
        if !hasLaunchedBefore  {
            print("First launch, storing UUID and hasLaunched-flag in UserDefaults")
            let uuid = NSUUID().UUIDString
            
            UserDefaults.setObject(uuid, forKey: UserDefaultKey.UUID)
            UserDefaults.setBool(true, forKey: UserDefaultKey.hasLaunchedBefore)
            print("Stored user ID \(uuid) in UserDefaults")
        }
        
        return true
    }
    
    // MARK: Notification delegates
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // This method is called when the app is launched (either normally or due to a local notification’s action)
        // This method can become useful in cases you need to check the existing settings and act depending on the values that will come up. Don’t forget that users can change these settings through the Settings app, so do never be confident that the initial configuration made in code is always valid.
        
        print(notificationSettings.types.rawValue)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // This method is called when a notification has been received while the app is in the foreground
        print("Received Local Notification:")
        print(notification.alertBody)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if identifier == "editList" {
            NSNotificationCenter.defaultCenter().postNotificationName("modifyListNotification", object: nil)
        }
        else if identifier == "trashAction" {
            NSNotificationCenter.defaultCenter().postNotificationName("deleteListNotification", object: nil)
        }
        
        completionHandler()
    }
    
    // MARK: Other lifecycle delegate methods

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

