//
//  MZDateUtils.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import Foundation

class FYDateUtils: NSObject {
    
    /// Date转换String
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - format: 格式
    /// - Returns: 字符串日期
    class func string(from date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter.init()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = format
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    /// 上个月
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 上月日期
    class func lastMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        dateCom.month = -1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    /// 上n个月
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 上月日期
    class func month(from date: Date, n: Int) -> Date {
        var dateCom = DateComponents()
        dateCom.month = n
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    
    /// 下个月
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 下个月日期
    class func nextMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        let abc = 1
        dateCom.month = +abc
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    /// 当月的天数
    ///
    /// - Parameter date: 日期
    /// - Returns: 天数
    class func daysInCurrMonth(date: Date) -> Int {
        let days: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return days.length
    }
    
    /// 当前月份的第一天是周几
    ///
    /// - Parameter date: 当前日期
    /// - Returns: 周几
    class func firstDayIsWeekInMonth(date: Date) -> Int {
        var calender = Calendar.current
        calender.firstWeekday = 1
        var com = (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        com.day = 1
        let firstDay = calender.date(from: com)
        let firstWeek = (calender as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: firstDay!)
        return firstWeek - 1
    }
    
    /// 当前月份的几号
    ///
    /// - Parameter date: 当前月份
    /// - Returns: 几号
    class func day(_ date: Date) -> Int {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.day!
    }
    
}
