//
//  HTMyCrouseViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMyCrouseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: HTProductDataSource!
    
    private var vm = HTProductVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    private func configView() {
        dataSource = HTProductDataSource(tableView)
    }
    
    private func request() {
        vm.type = "2"
        vm.requestProducts {[weak self] (success) in
            self?.tableView.mj_header?.endRefreshing()
            self?.dataSource.resetData(self?.vm.dataSource)
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
