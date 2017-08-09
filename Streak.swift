//
//  Streak.swift
//  Sprek
//
//  Created by Eli Yazdi on 8/7/17.
//  Copyright © 2017 Eli Yazdi. All rights reserved.
//

import Foundation
import RealmSwift

class Streak{
    static var days: Int{
        let realm = try! Realm(configuration: MyRealm.config)
        let activities = realm.objects(Activity.self).sorted(byKeyPath: "date", ascending: false)
        if(activities.count > 0){
            var completed: [Activity] = []
            for activity in activities{
                let hoursFromNow = Date().hours(from: activity.date)
                if(completed.count == 0 && hoursFromNow < 24){
                    completed.append(activity)
                }else if(completed.count > 0){
                    let hoursFromLast = completed.last?.date.hours(from: activity.date)
                    if(hoursFromLast! < 24){
                        completed.append(activity)
                    }else{
                        break
                    }
                }
            }
            var dates: [String] = []
            for activity in completed{
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                formatter.timeZone = .current
                let formatted = formatter.string(from: activity.date)
                if(dates.count == 0){
                    dates.append(formatted)
                }else if(dates.last != formatted){
                    dates.append(formatted)
                }
            }
            return dates.count
        }else{
            return 0
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
