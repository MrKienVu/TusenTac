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

    static let primaryColor = UIColor(red: 0.0078, green: 0.7607, blue: 0.6588, alpha: 1)
    static let secondaryColor = UIColor.lightGrayColor()
}

struct UserDefaultKey {
    static let morningTime = "TusenTacMorningTime"
    static let nightTime = "TusenTacNightTime"
    static let morningDosage = "TusenTacMorningDosage"
    static let nightDosage = "TusenTacNightDosage"
    
    static let hasLaunchedBefore = "HasLaunchedBefore"
    static let UUID = "UUID"
    static let NotificationsEnabled = "NotificationsEnabled"
    static let StudyID = "StudyID"
    
    static let Weight = "weight"
    static let lastDosageTime = "LastDosageTime"
}