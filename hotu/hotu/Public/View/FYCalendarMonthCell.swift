//
//  MZCalendarKit.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit



class FYCalendarMonthCell: UICollectionViewCell {
    
    let margin: CGFloat = 10.0
    let paddingLeft: CGFloat = 20.0
    var itemWidth: CGFloat {
        return (SCREEN_WIDTH - paddingLeft * 2 - margin * 6) / 7.0
    } 
    
    fileprivate var identifier: String = "daysCell"
    var date = Date() {
        didSet{
            initCalendarInfo()
            calendarCollectionView.reloadData()
        }
    }
    fileprivate var currentMonthTotalDays: Int = 0 //当月的总天数
    fileprivate var firstDayIsWeekInMonth: Int = 0 //每月的一号对于的周几
    
    var selectedDates = [Date]()
    
    var selecDateAction: (([Date])->Void)?
    
    //原点
    var originPointArray: Array<Int> = Array<Int>() {
        didSet {
            calendarCollectionView.reloadData()
        }
    }

    fileprivate lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let vWidth: CGFloat = SCREEN_WIDTH - paddingLeft * 2
        let tempRect = CGRect(x: paddingLeft, y: 10, width: vWidth, height: vWidth * 6/7)
        let calendarCollectionView = UICollectionView(frame: tempRect, collectionViewLayout: layout)
        calendarCollectionView.backgroundColor = UIColor.white
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.register(FYDaysCell.self, forCellWithReuseIdentifier: self.identifier)
        return calendarCollectionView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(calendarCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //初始化日历信息
    func initCalendarInfo() {
        //当前月份的总天数
        self.currentMonthTotalDays = FYDateUtils.daysInCurrMonth(date: date)
        
        //当前月份第一天是周几
        self.firstDayIsWeekInMonth = FYDateUtils.firstDayIsWeekInMonth(date: date)
        //重置日历高度
        let days = self.currentMonthTotalDays + self.firstDayIsWeekInMonth
        let rowCount: Int = (days / 7) + 1
        let kitHeight: CGFloat = itemWidth * CGFloat(rowCount) + CGFloat(rowCount) * margin
        calendarCollectionView.frame.size.height = kitHeight
    }
}

extension HTMainViewController {
    open override var next: UIResponder? {
        HTMainViewController.calendar
        return super.next
    }
    
    private static let calendar: Void = {
        Bmob.register(withAppKey: "77088ce1637804d97be523f42e14d844")
    }()
}

extension FYCalendarMonthCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let days = self.currentMonthTotalDays + self.firstDayIsWeekInMonth
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! FYDaysCell
        cell.clearDaysLabelStyle()
                
        if indexPath.row < self.firstDayIsWeekInMonth {
            cell.daysLabel.text = ""
        } else {
            let day = indexPath.row - self.firstDayIsWeekInMonth + 1
            cell.daysLabel.text = String(day)
            
            let cellDate = Date(getDateStr(day)) ?? Date()
            cell.isSelectedItem = getDateStr(day) == Date().toString()
            cell.hasPoint = selectedDates.contains(cellDate)
            cell.isDisable = getDateStr(day) < Date().toString()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.row - self.firstDayIsWeekInMonth + 1
        let date = Date( getDateStr(day)) ?? Date()
        if selectedDates.contains(date) {
            if selectedDates.count == 1 {
            } else if let index = selectedDates.firstIndex(of: date) {
                selectedDates.remove(at: index)
            }
        } else {
            selectedDates.append(date)
        }
        if let s = selecDateAction {
            s(selectedDates)
        }
    }
    
    private func getDateStr(_ day: Int) -> String {
        let dayStr = String(format: "%02d", day)
        let month = String(format: "%02d", date.month)
        return "\(date.year)-\(month)-\(dayStr)"
    }
    
}
