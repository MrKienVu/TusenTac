//
//  Constants.swift
//  Mathys
//
//  Created by ingeborg ødegård oftedal on 15/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

let UserDefaults = NSUserDefaults.standardUserDefaults()

struct Color {

    static let primaryColor = UIColor(red: 0, green: 176/255, blue: 173/255, alpha: 1)
    static let secondaryColor = UIColor.lightGrayColor()
}

struct UserDefaultKey {
    static let morningTime = "TusenTacMorningTime"
    static let nightTime = "TusenTacNightTime"
    static let morningDosage = "TusenTacMorningDosage"
    static let nightDosage = "TusenTacNightDosage"

    static let hasLaunchedBefore = "HasLaunchedBefore"
    static let UUID = "UUID"
    static let StudyID = "StudyID"
    static let PersonNumber = "PersonNumber"
    
    static let NotificationsEnabled = "NotificationsEnabled"
    
    static let CompletedOnboarding = "CompletedOnboarding"
    
    static let Weight = "Weight"
    static let LastWeightTime = "LastWeightTime"
    static let LastDosageTime = "LastDosageTime"
    
    static let morningSwitchOn = "MorningSwitchOn"
    static let nightSwitchOn = "NightSwitchOn"
    
    static let hasSendtMorningNotification = "HasSendtMorningNotification"
    static let hasSendtNightNotification = "HasSendtNightNotification"
    static let hasSendtWeightNotification = "HasSendtWeightNotification"
}