//
//  DateTimeFormatter.swift
//  
//
//  Created by Stanislav Makushov on 31.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation

class DateTimeFormatter {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let outputServerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
    
    class func timeString(from date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    class func date(from string: String) -> Date? {
        return outputDateFormatter.date(from: string)
    }
    
    class func string(from date: Date, withTime: Bool = false) -> String {
        return withTime == true ? dateTimeFormatter.string(from: date) : dateFormatter.string(from: date)
    }
    
    class func formattedString(from string: String) -> String? {
        if let date = DateTimeFormatter.date(from: string) {
            return DateTimeFormatter.string(from: date)
        }
        
        return nil
    }
    
    class func shortString(from date: Date) -> String {
        return shortDateFormatter.string(from: date)
    }
    
    class func timeStringFromNumberOfSeconds(seconds interval: Double) -> String {
        if interval.isNaN {
            return "0:00"
        } else {
            let interval = Int(interval)
            let seconds = interval % 60
            let minutes = (interval / 60) % 60
            let hours = (interval / 3600)
            
            if hours == 0 {
                return String(format: "%02d:%02d", minutes, seconds)
            }
            
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
