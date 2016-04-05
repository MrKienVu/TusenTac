//
//  StringExtensions.swift
//  MedForsk
//
//  Created by Paul Philip Mitchell on 16/07/15.
//  Copyright (c) 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}

extension NSDate {
    func getCurrentLocalDate()-> NSDate {
        var now = NSDate()
        let nowComponents = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        nowComponents.year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: now)
        nowComponents.month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: now)
        nowComponents.day = NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: now)
        nowComponents.hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: now)
        nowComponents.minute = NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: now)
        nowComponents.second = NSCalendar.currentCalendar().component(NSCalendarUnit.Second, fromDate: now)
        nowComponents.timeZone = NSTimeZone(abbreviation: "GMT")
        now = calendar.dateFromComponents(nowComponents)!
        return now
    }
    
    func toStringShortStyle() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
    
    func toStringHourMinute() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
}

