//
//  HTMyActivityViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMyActivityViewController: UIViewController {
    
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var matchTableView: UITableView!
    
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var contentScrollView: UIScrollView!
    private var activityDataSource: HTActivityDataSource!
    private var matchDataSource: HTActivityDataSource!
    
    private var isTapSegment = false

    private var activityVM = HTActivityVM()
    private var matchVM = HTActivityVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        request()
        firstRequest()
    }
    
    private func configView() {
        segment.titleArray = ["活动", "赛事"]
        segment.selectAction = { index in
            self.isTapSegment = true
            self.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self.firstRequest()
        }
        activityDataSource = HTActivityDataSource(activityTableView)
        matchDataSource = HTActivityDataSource(matchTableView)
    }
    
    private func firstRequest() {
        switch segment.selectedIndex {
        case 0:
            if activityVM.dataSource.count == 0 {
                activityTableView.mj_header?.beginRefreshing()
            }
        default:
            if matchVM.dataSource.count == 0 {
                matchTableView.mj_header?.beginRefreshing()
            }
        }
    }
    
    private func request() {
        activityTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestActivity()
        })
        matchTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestMatch()
        })
        
    }
    
    private func requestActivity() {
        self.activityVM.type = "0"
        activityVM.requestMyActivity { [weak self] (success) in
            self?.activityDataSource.resetData(self?.activityVM.dataSource)
            self?.activityTableView.mj_header?.endRefreshing()
        }
    }
    
    private func requestMatch() {
        self.matchVM.type = "2"
        matchVM.requestMyActivity { [weak self] (success) in
            self?.matchDataSource.resetData(self?.matchVM.dataSource)
            self?.matchTableView.mj_header?.endRefreshing()
        }
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

extension HTMyActivityViewController: UIScrollViewDelegate {
    
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
