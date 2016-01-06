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
    static let primaryColor = UIColor(red: 0.0078, green: 0.7607, blue: 0.6588, alpha: 1)
    static let secondaryColor = UIColor.lightGrayColor()
}

struct UserDefaultKey {
    static let morningTime = "TusenTacMorningTime"
    static let bedTime = "TusenTacBedTime"
    static let dosage = "TusenTacDosage"
    static let hasLaunchedBefore = "HasLaunchedBefore"
    static let UUID = "UUID"
    static let NotificationsEnabled = "NotificationsEnabled"
}