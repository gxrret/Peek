//
//  DateHelper.swift
//  Peek
//
//  Created by Garret Koontz on 2/8/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func timeAgoSinceComments(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)w"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)d"
        }
        
        if let day = components.day, day >= 1 {
            return "1 day ago"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)h"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "1h"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)m"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "1m"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)s"
        }
        
        return "Just now"
        
    }
    
    static func timeAgoSincePeek(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)w"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) DAYS AGO"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) HOURS AGO"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "AN HOUR AGO"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) MINUTES AGO"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A MINUTE AGO"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) SECONDS AGO"
        }
        
        return "Just now"
        
    }

}
