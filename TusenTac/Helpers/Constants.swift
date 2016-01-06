//
//  Constants.swift
//  Mathys
//
//  Created by ingeborg ødegård oftedal on 15/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//

import Foundation
import UIKit

let UserDefaults = NSUserDefaults.standardUserDefaults()

struct Color {
    static let primaryColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    static let secondaryColor = UIColor.lightGrayColor()
}

let Days: [Int: String] = [
    0: "Mandag",
    1: "Tirsdag",
    2: "Onsdag",
    3: "Torsdag",
    4: "Fredag",
    5: "Lørdag",
    6: "Søndag"
]

struct UserDefaultKey {
    static let morningTime = "TusenTacMorningTime"
    static let nightTime = "TusenTacNightTime"
    static let mDosage = "TusenTacMorningDosage"
    static let nDosage = "TusenTacNightDosage"
    
    static let hasLaunchedBefore = "HasLaunchedBefore"
    static let UUID = "UUID"
    static let NotificationsEnabled = "NotificationsEnabled"
}