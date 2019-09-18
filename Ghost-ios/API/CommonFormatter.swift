//
//  KFormatter.swift
//  KBase
//
//  Created by Criss Myers on 22/08/2017.
//  Copyright © 2017 missionlabs. All rights reserved.
//

import Foundation

/**
 Global Formatter class to convert various values
 */
public class CommonFormatter {
    
    //MARK: Init
    public init() {}
    
    //MARK: Date Formatting
    public class func stringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    public class func stringToUnix(_ string: String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: string)        
        return date!.timeIntervalSince1970
    }
    
    public class func stringToDate(_ string: String, with format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    public class func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
    
    public class func dateToUnixTS(_ date: Date) -> String {
        return String(Int(date.timeIntervalSince1970))
    }
    
    public class func dateToUnixTimeStamp(_ date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    public class func unixToDate(_ unix: Int) -> Date {
        let timeInterval = TimeInterval(unix)
        return  Date(timeIntervalSince1970: timeInterval)
    }
    
    public class func stringToTime(_ string: String) -> Date {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss"
        let time = timeFormatter.date(from: string)
        return time!
    }
    
    public class func timeTo24Hours(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm"
        // timeFormatter.amSymbol = "am"
        // timeFormatter.pmSymbol = "pm"
        return timeFormatter.string(from: date)
    }
    
    public class func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
    
    //MARK: Price Formatting
    public class func price(_ amount: Int, currencyCode: String) -> String {
        let pounds = amount/100
        let pence = amount%100
        var penceString = String(pence)
        if pence > 0 && pence < 10 {
            penceString = "0\(pence)"
        }        
        if pence > 0 {
            return "£\(pounds).\(penceString)"
        } else {
            return "£\(pounds)"
        }
    }
    
//    public var contactStartDate:Date = {
//        let timeFormatter = DateFormatter()
//        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
//        timeFormatter.timeZone = TimeZone.current
//        timeFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = "2018-01-01"
//        return timeFormatter.date(from: dateString) ?? Date()
//    }()
//
//    //MARK: Default Values
//    public var introStartDate:Date = {
//        let timeFormatter = DateFormatter()
//        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
//        timeFormatter.timeZone = TimeZone.current
//        timeFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = "2018-10-08"
//        return timeFormatter.date(from: dateString) ?? Date()
//    }()
//
//    public class func fileDate(_ date: NSDate) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "yyyy-MM-dd-HH'h'mm'm'ss's'"
//        return dateFormatter.string(from: date as Date)
//    }
    
//    public class func fromNow(_ date: Date) -> String {
//        let now = Date()
//        if date.isToday {
//            let diff = Calendar.current.dateComponents([.hour], from: date, to: now).hour
//            if diff == 0 {
//                let diff = Calendar.current.dateComponents([.minute], from: date, to: now).minute
//                if diff! < 5 {
//                    return "now"
//                }
//                return "\(diff ?? 0)min ago"
//            }
//            return "\(diff ?? 0)h ago"
//        }
//        if date.isYesterday {
//            return "1d ago"
//        }
//        if date.isThisMonth || date.isLastWeek {
//            let diff = Calendar.current.dateComponents([.day], from: date, to: now).day
//            return "\(diff ?? 0)d ago"
//        } else {
//            return date.formatted(false, day: true, month: true, year: true)
//        }
//    }
}
