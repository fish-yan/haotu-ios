//
//  HTNotificationViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/3.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTNotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [HTNoticeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
    }
    

    func request() {
        FYNetWork.request("im/user/notify/listNoticeByUserId", isLoading: false).responseJSON { (response: HTBaseModel<[HTNoticeModel]>) in
            if let data = response.data {
                self.dataSource = data
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.reloadData()
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

extension HTNotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTNotiListCell", for: indexPath) as! HTNotiListCell
        cell.model = dataSource[indexPath.row]
        cell.complete = {
            tableView.mj_header?.beginRefreshing()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
}
