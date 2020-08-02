//
//  HTMyPolicyViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMyPolicyViewController: UIViewController {
    
    @IBOutlet weak var allTableView: UITableView!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var contentScrollView: UIScrollView!

    private var allDataSource: HTPolicyDataSource!

    private var dataSource1 = [HTPolicyModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        allDataSource = HTPolicyDataSource(allTableView)
        request()
    }

    private func request() {
        allTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestAllPolicy()
        })
        allTableView.mj_header?.beginRefreshing()
    }
    
    
    private func requestAllPolicy() {
        requestMyPolicyList { [weak self] (success) in
            self?.allTableView.mj_header?.endRefreshing()
            self?.allDataSource.resetData(self?.dataSource1)
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


extension HTMyPolicyViewController {
    func requestMyPolicyList(complete: @escaping(Bool)->Void) {
        let params = ["type": "0"] // (0:全部、1：责任险2、意外险)
        FYNetWork.request(MY_POLICY_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTPolicyModel]>) in
            if let d = response.data {
                self.dataSource1 = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
}
