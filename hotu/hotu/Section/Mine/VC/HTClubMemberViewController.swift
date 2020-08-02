//
//  HTClubMemberViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
enum HTMemberListType {
    case group, attention, funs, all, attentionAndFuns
}

class HTClubMemberViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: HTFriendDataSource!
        
    var vm = HTFriendVM()
    
    var clubVM = HTClubVM()
    
    var complete: ((HTMemberModel)->Void)?
    
    var type: HTMemberListType  = .group // 0：群成员， 1：我关注的，2：粉丝
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.configData()
        })
        tableView.mj_header?.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(msgChanged), name: .HTBadgeChanged, object: nil)
    }
    
    private func configView() {
        dataSource = HTFriendDataSource(tableView)
    }
    
    @objc func msgChanged(_ notification: Notification) {
        tableView.mj_header?.beginRefreshing()
    }
    
    private func configData() {
        switch type {
        case .group:
            requestClubMember()
        default:
            request()
        }
    }
    
    private func requestClubMember() {
        clubVM.requestClubMemberList {  [weak self] (success) in
            self?.tableView.mj_header?.endRefreshing()
            self?.setData()
        }
    }
    
    private func request() {
        vm.requestGetFrend { [weak self] (success) in
            self?.tableView.mj_header?.endRefreshing()
            self?.setData()
        }
    }
    
    private func setData() {
        var arr = [HTMemberModel]()
        switch type {
        case .all:
            arr = vm.memberList
        case .funs:
            arr = vm.memberList.filter({$0.status == "2" || $0.status == "3"})
        case .attention:
            arr = vm.memberList.filter({$0.status == "1" || $0.status == "3"})
        case .attentionAndFuns:
            arr = vm.memberList.filter({$0.status == "3"})
        case .group:
            arr = clubVM.memberList
        }
        dataSource.resetData(arr)
        dataSource.reloadData = {
            self.configData()
        }
        if let c = complete {
            dataSource.didSelectRow = { (indexPath, model) in
                c(model)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTBadgeChanged, object: nil)
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
