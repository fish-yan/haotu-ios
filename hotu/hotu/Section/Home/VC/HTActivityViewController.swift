//
//  HTActivityViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import MJRefresh
import RongIMKit

class HTActivityViewController: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var allTableView: UITableView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var matchTableView: UITableView!
    
    @IBOutlet weak var dateView: UIScrollView!
    @IBOutlet weak var calendarView: FYCalendar!
    @IBOutlet weak var segment: FYSegment!
    
    private var isTapSegment = false
    
    private var allDataSource: HTActivityDataSource!
    
    private var activityDataSource: HTActivityDataSource!
    
    private var matchDataSource: HTActivityDataSource!
    
    private var allVM = HTActivityVM()
    private var activityVM = HTActivityVM()
    private var matchVM = HTActivityVM()
    
    private var allNeedRefresh = false
    private var activityNeedRefresh = false
    private var matchNeedRefresh = false
    
    private var lastIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        request()
        firstRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .HTActivityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .HTMatchChanged, object: nil)
        
        
    }
    
    private func configView() {

        segment.titleArray = ["全部", "活动", "赛事", "时间"]
        segment.selectAction = { index in
            self.isTapSegment = true
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            if index != 3 {
                self.lastIndex = index
            }
            self.segment.btnArray.last?.isHidden = index == 2
            self.firstRequest()
        }
        calendarView.selectDateAction = { dates in
            let str = dates.map({$0.toString("yyyy-MM-dd HH:mm:ss")}).joined(separator: ",")
            self.allVM.activity_date = str
            self.activityVM.activity_date = str
            self.matchVM.activity_date = str
            self.allTableView.mj_header?.beginRefreshing()
            self.activityTableView.mj_header?.beginRefreshing()
            self.matchTableView.mj_header?.beginRefreshing()
            self.segment.selectedIndex = self.lastIndex
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(self.lastIndex) * SCREEN_WIDTH, y: 0), animated: true)
        }
        
        allDataSource = HTActivityDataSource(allTableView)
        allDataSource.hasAd = true
        allDataSource.hasGroupNm = true
        activityDataSource = HTActivityDataSource(activityTableView)
        activityDataSource.hasAd = true
        activityDataSource.hasGroupNm = true
        matchDataSource = HTActivityDataSource(matchTableView)
        matchDataSource.hasAd = true
        matchDataSource.hasGroupNm = true
    }
    
    @objc private func refresh() {
        allNeedRefresh = true
        activityNeedRefresh = true
        matchNeedRefresh = true
        firstRequest()
    }
    
    func firstRequest() {
        switch segment.selectedIndex {
        case 0:
            if allVM.dataSource.count == 0 || allNeedRefresh {
                self.allTableView.mj_header?.beginRefreshing()
                allNeedRefresh = false
            }
        case 1:
            if activityVM.dataSource.count == 0 || activityNeedRefresh {
                self.activityTableView.mj_header?.beginRefreshing()
                activityNeedRefresh = false
            }
        case 2:
            if matchVM.dataSource.count == 0 || matchNeedRefresh {
                self.matchTableView.mj_header?.beginRefreshing()
                matchNeedRefresh = false
            }
        default:
            break
        }

    }
    
    private func request() {
        allTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.allVM.pageIndex = 1
            self.requestAllActivity()
        })
        allTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.allVM.pageIndex += 1
            self.requestAllActivity()
        })
        
        activityTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.activityVM.pageIndex = 1
            self.requestActivity()
        })
        activityTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.activityVM.pageIndex += 1
            self.requestActivity()
        })
        
        matchTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.matchVM.pageIndex = 1
            self.requestMatchActivity()
        })
    }
    
    private func requestAllActivity() {
        self.allVM.type = "99"
        self.allVM.requestActivity { [weak self] (success) in
            self?.allDataSource.resetData(self?.allVM.dataSource)
            self?.allTableView.mj_header?.endRefreshing()
            self?.allTableView.mj_footer?.endRefreshing()
        }
    }
    
    private func requestActivity() {
        self.activityVM.type = "0"
        self.activityVM.requestActivity { [weak self] (success) in
            self?.activityDataSource.resetData(self?.activityVM.dataSource)
            self?.activityTableView.mj_header?.endRefreshing()
            self?.activityTableView.mj_footer?.endRefreshing()
        }
    }
    
    private func requestMatchActivity() {
        self.matchVM.type = "2"
        self.matchVM.requestActivity { [weak self] (success) in
            self?.matchDataSource.resetData(self?.matchVM.dataSource)
            self?.matchTableView.mj_header?.endRefreshing()
            self?.matchTableView.mj_footer?.endRefreshing()
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTActivityChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTMatchChanged, object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HTActivityViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            isTapSegment = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            if !isTapSegment {
                segment.process = contentScrollView.contentOffset.x / contentScrollView.contentSize.width
            }
        }
    }
}
