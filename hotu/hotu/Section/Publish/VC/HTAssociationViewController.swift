//
//  HTAssociationViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAssociationViewController: UIViewController {
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var clubTableView: UITableView!
    @IBOutlet weak var mercTableView: UITableView!
    @IBOutlet weak var coachTableView: UITableView!
    
    
    @IBOutlet weak var segment: FYSegment!
    
    @IBOutlet weak var activeSearchTF: UITextField!
    @IBOutlet weak var clubSearchTF: UITextField!
    @IBOutlet weak var mercSearchTF: UITextField!
    @IBOutlet weak var coachSearchTF: UITextField!
    
    
    private var activityDataSource: HTActivityDataSource!
    private var clubDataSource: HTClubDataSource!
    private var mercDataSource: HTClubDataSource!
    private var coachDataSource: HTClubDataSource!
    
    private var activityVM = HTActivityVM()
    private var clubVM = HTClubVM()
    private var mercVM = HTClubVM()
    private var coachVM = HTClubVM()
    
    private var isTapSegment = false
    
    var completeActivity: ((HTActivityModel)->Void)?
    
    var completeClub: ((HTClubModel)->Void)?
    
    var completeCoach: ((HTClubModel)->Void)?
    
    var completeMerc: ((HTClubModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        request()
        firstRequest()
    }
    
    private func configView() {
        activityTableView.superview?.isHidden = true
        clubTableView.superview?.isHidden = true
        mercTableView.superview?.isHidden = true
        coachTableView.superview?.isHidden = true
        switch HTUserInfo.share.role {
        case .coach:
            segment.titleArray = ["俱乐部", "教练"]
            clubTableView.superview?.isHidden = false
            coachTableView.superview?.isHidden = false
        case .merc:
            segment.titleArray = ["俱乐部", "商铺"]
            clubTableView.superview?.isHidden = false
            mercTableView.superview?.isHidden = false
        case .club:
            segment.titleArray = ["活动赛事", "俱乐部"]
            activityTableView.superview?.isHidden = false
            clubTableView.superview?.isHidden = false
        case .all:
            segment.titleArray = ["活动赛事", "俱乐部", "商铺", "教练"]
            activityTableView.superview?.isHidden = false
            clubTableView.superview?.isHidden = false
            mercTableView.superview?.isHidden = false
            coachTableView.superview?.isHidden = false
        default: break
        }
        
        segment.selectAction = { [weak self] index in
            self?.isTapSegment = true
            self?.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self?.firstRequest()
        }
        activityDataSource = HTActivityDataSource(activityTableView)
        activityDataSource.didSelectRow = { (indexPath, model) in
            if let c = self.completeActivity {
                c(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
        clubDataSource = HTClubDataSource(clubTableView)
        clubDataSource.type = .club
        clubDataSource.didSelectRow = { (indexPath, model) in
            if let c = self.completeClub {
                c(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
        mercDataSource = HTClubDataSource(mercTableView)
        mercDataSource.type = .merc
        mercDataSource.didSelectRow = { (indexPath, model) in
            if let c = self.completeCoach {
                c(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
        coachDataSource = HTClubDataSource(coachTableView)
        coachDataSource.type = .coach
        coachDataSource.didSelectRow = { (indexPath, model) in
            if let c = self.completeMerc {
                c(model)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func firstRequest(_ refresh: Bool = false) {
        switch segment.titleArray[segment.selectedIndex] {
        case "活动赛事":
            if activityVM.dataSource.isEmpty || refresh {
                activityTableView.mj_header?.beginRefreshing()
            }
        case "俱乐部":
            if clubVM.dataSource.isEmpty  || refresh {
                clubTableView.mj_header?.beginRefreshing()
            }
        case "商铺":
            if mercVM.dataSource.isEmpty || refresh {
                mercTableView.mj_header?.beginRefreshing()
            }
        case "教练":
            if coachVM.dataSource.isEmpty || refresh {
                coachTableView.mj_header?.beginRefreshing()
            }
        default:
            break
        }
    }
    
    private func request() {
        activityTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.activityVM.pageIndex = 1
            self.requestActivity()
        })
        activityTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.activityVM.pageIndex += 1
            self.requestActivity()
        })
        clubTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.clubVM.pageIndex = 1
            self.requestClub()
        })
        clubTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.clubVM.pageIndex += 1
            self.requestClub()
        })
        coachTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.coachVM.pageIndex = 1
            self.requestCoach()
        })
        coachTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.coachVM.pageIndex += 1
            self.requestCoach()
        })
        mercTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.mercVM.pageIndex = 1
            self.requestMerc()
        })
        mercTableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.mercVM.pageIndex += 1
            self.requestMerc()
        })
    }
    
    private func requestActivity() {
        activityVM.keyword = activeSearchTF.text ?? ""
        activityVM.requestAssociationActivity { [weak self] (success) in
            self?.activityTableView.mj_header?.endRefreshing()
            self?.activityTableView.mj_footer?.endRefreshing()
            self?.activityDataSource.resetData(self?.activityVM.dataSource)
        }
    }
    
    private func requestClub() {
        clubVM.keyword = clubSearchTF.text ?? ""
        clubVM.requestAssoMCC(type: "1") { [weak self] (success) in
            self?.clubTableView.mj_header?.endRefreshing()
            self?.clubTableView.mj_footer?.endRefreshing()
            self?.clubDataSource.resetData(self?.clubVM.dataSource)
        }
    }
    
    private func requestCoach() {
        coachVM.keyword = coachSearchTF.text ?? ""
        coachVM.requestAssoMCC(type: "3") { [weak self] (success) in
            self?.coachTableView.mj_header?.endRefreshing()
            self?.coachTableView.mj_footer?.endRefreshing()
            self?.coachDataSource.resetData(self?.coachVM.dataSource)
        }
    }
    
    private func requestMerc() {
        mercVM.keyword = mercSearchTF.text ?? ""
        mercVM.requestAssoMCC(type: "5") { [weak self] (success) in
            self?.mercTableView.mj_header?.endRefreshing()
            self?.mercTableView.mj_footer?.endRefreshing()
            self?.mercDataSource.resetData(self?.mercVM.dataSource)
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

extension HTAssociationViewController: UIScrollViewDelegate {
    
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

extension HTAssociationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstRequest(true)
        return true
    }
}
