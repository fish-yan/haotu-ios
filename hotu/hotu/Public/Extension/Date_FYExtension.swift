//
//  Date_FYExtension.swift
//  Crabs_star
//
//  Created by FishYan on 2018/1/19.
//  Copyright © 2018年 com.newlandcomputer.app. All rights reserved.
//

import UIKit

enum FYWeekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

extension Date {
    /// 当前日历组件
    var components: DateComponents {
        get {
            return Calendar.current.dateComponents(in: .current, from: self)
        }
    }
    
    /// 日
    var day: Int {
        get {
            return components.day ?? 0
        }
    }
    
    /// 月
    var month: Int {
        get {
            return components.month ?? 0
        }
    }
    
    /// 年
    var year: Int {
        get {
            return components.year ?? 0
        }
    }
    
    /// 当月天数
    var daysInMonth: Int {
        get {
            if let range = Calendar.current.range(of: .day, in: .month, for: self) {
                return range.count
            }
            return 0
        }
    }
    /// 用日期字符换初始化日期， formatter 默认 yyyy-MM-dd
    init?(_ str: String, formatter: String = "yyyy-MM-dd") {
        if str.isEmpty {return nil}
        let format = DateFormatter()
        format.dateFormat = formatter
        guard let date = format.date(from: str) else { return nil }
        self.init(timeInterval: 0, since: date)
    }
    
    /// Date -> String foarmtter 默认 yyyy-MM-dd
    func toString(_ formatter: String = "yyyy-MM-dd") -> String {
        let format = DateFormatter()
        format.dateFormat = formatter
        return format.string(from: self)
    }
    
    /// 当月第几日所在的日期
    /// day：日，范围（1...该月总天数）
    func dateOfMonth(day: Int) -> Date {
        var tempDay = day
        if tempDay > daysInMonth || tempDay <= 0 {
            if tempDay <= 0 {
                print("传入日范围溢出，日最小为1，返回第一日")
                tempDay = 1
            }
            if tempDay > daysInMonth {
                print("传入日范围溢出，日最大为\(daysInMonth)，返回最后一日")
                tempDay = daysInMonth
            }
        }
        let tempComponent = DateComponents(year: components.year, month: components.month, day: tempDay)
        return Calendar.current.date(from: tempComponent) ?? self
    }
    
    /// 当周周几所在的日期
    /// firstWeekday:一周的开始日
    /// weekday传入将要查询的周几
    /// 返回要查询的日期
    func dateInWeek(firstWeekday: FYWeekday = .sunday, weekday: FYWeekday) -> Date {
        var space = weekday.rawValue
        
        var calendar = Calendar.current
        calendar.firstWeekday = firstWeekday.rawValue
        let component = calendar.dateComponents(in: .current, from: self)
        if component.weekday! < firstWeekday.rawValue {
            space -= 7
        }
        
        if weekday.rawValue < firstWeekday.rawValue {
            space += 7
        }
        
        let date2 = calendar.date(byAdding: .day, value: space - component.weekday!, to: self)
        return date2 ?? self
    }
    
    /// 当月一共有几周
    /// firstWeekday：一周的开始日
    func weeksInMonth(firstWeekday: FYWeekday) -> Int {
        let mFirstday = self.dateOfMonth(day: 1)
        let wFirstday = mFirstday.dateInWeek(firstWeekday: firstWeekday, weekday: firstWeekday)
        let mLastday = self.dateOfMonth(day: self.daysInMonth)
        let lastWeekday = (firstWeekday.rawValue + 5) % 7 + 1
        let wLastday = mLastday.dateInWeek(firstWeekday: firstWeekday, weekday: FYWeekday(rawValue: lastWeekday)!)
        let interval = wLastday.timeIntervalSince(wFirstday) + 24 * 3600
        return Int(interval/(7 * 24 * 3600))
    }
    
    /// 日期所在该月的第几周,
    /// firstWeekday：一周的开始日
    func weekOfMonth(firstWeekday: FYWeekday) -> Int {
        let mFirstday = self.dateOfMonth(day: 1)
        let wFirstday = mFirstday.dateInWeek(firstWeekday: firstWeekday, weekday: firstWeekday)
        let interval = self.timeIntervalSince(wFirstday)
        return Int(interval/(7 * 24 * 3600)) + 1
    }
    
    /// 当月第 n 周的起始日期和结束日期
    /// firstWeekday：一周的开始日
    /// weekOfMonth：第几周，（范围1...当月总周数）
    func dateOfWeek(firstWeekday: FYWeekday, weekOfMonth: Int) -> (Date, Date) {
        var tempWeek = weekOfMonth
        if tempWeek > weeksInMonth(firstWeekday: firstWeekday) || tempWeek <= 0 {
            if tempWeek <= 0 {
                print("传入周范围溢出，周最小为1，返回第一周")
                tempWeek = 1
            }
            if tempWeek > weeksInMonth(firstWeekday: firstWeekday) {
                print("传入周范围溢出，周最大为\(weeksInMonth(firstWeekday: firstWeekday))，返回最后一周")
                tempWeek = weeksInMonth(firstWeekday: firstWeekday)
            }
        }
        let mFirstday = self.dateOfMonth(day: 1)
        let wFirstday = mFirstday.dateInWeek(firstWeekday: firstWeekday, weekday: firstWeekday)
        let beginDate = Calendar.current.date(byAdding: .day, value: (tempWeek - 1) * 7, to: wFirstday) ?? self
        let lastWeekday = (firstWeekday.rawValue + 5) % 7 + 1
        let endDate = beginDate.dateInWeek(firstWeekday: firstWeekday, weekday: FYWeekday(rawValue: lastWeekday)!)
        return (beginDate, endDate)
    }
}
