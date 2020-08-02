//
//  HTMemberListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/14.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMemberListViewController: UITableViewController {
    
    var dataSource = [HTMemberModel]()
    
    private let cellKey = "HTNormalCell"
    
    private let cellKey1 = "HTFriendCell"
    
    var activityId = ""
    
    var type = 0
    
    var keyword = ""
    
    var page = 1
    
    var selectedArr = [HTMemberModel]()
    
    var complete: (([HTMemberModel])->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        tableView.register(UINib(nibName: cellKey1, bundle: nil), forCellReuseIdentifier: cellKey1)
        if type == 1 {
            configMJ()
        }
    }
    
    private func configMJ() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request()
        })
        tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.page += 1
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    private func request() {
        requestAnchorList { (success) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            for model in self.dataSource {
                if !self.selectedArr.filter({$0.user_id == model.user_id}).isEmpty {
                    model.isSelected = true
                }
            }            
            self.tableView.reloadData()
        }
    }
    
    
    override func navigationShouldPop() -> Bool {
        if let c = complete {
            selectedArr = dataSource.filter({$0.isSelected})
            c(selectedArr)
        }
        return true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        if type == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellKey1, for: indexPath) as! HTFriendCell
            cell.model = model
            cell.attentionBtn.setTitle("选定", for: .normal)
            cell.attentionBtn.setTitle("已选定", for: .selected)
            cell.attentionBtn.setBackgroundImage(UIImage(named: "icon_enable_red"), for: .selected)
            cell.attentionBtn.setTitleColor(.white, for: .selected)
            cell.attentionBtn.isSelected = model.isSelected
            cell.attentionAction = { m in
                m.isSelected = !m.isSelected
                tableView.reloadData()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTNormalCell
            cell.imgV.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            cell.titLab.text = model.nick_name
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HTSearchTFHeader(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 56))
        header.tfReturnAction = { tf in
            self.keyword = tf.text ?? ""
            self.tableView.mj_header?.beginRefreshing()
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if type == 1 {
            return 56
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
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

extension HTMemberListViewController {
    func requestAnchorList(complete: @escaping(Bool)->Void) {
        let params = ["activityId": activityId, "keyword":keyword, "pageIndex": "\(page)", "pageSize":"20"]
        FYNetWork.request(ANCHOR_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTMemberModel]>) in
            if self.page == 1 {
                self.dataSource = [HTMemberModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
}
