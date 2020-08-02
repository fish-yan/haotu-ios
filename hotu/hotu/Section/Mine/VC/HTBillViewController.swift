//
//  HTBillViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/7.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import BRPickerView

class HTBillViewController: UIViewController {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var vm = HTWalletVM()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.month = Date().toString("yyyy年MM月")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    private func request() {
        vm.requestBillList { (success) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.reloadData()
            self.desLab.text = "支出￥\(self.vm.billModel.payed) 收入￥\(self.vm.billModel.harvest) "
        }
    }
    
    @IBAction func dateAction(_ sender: UIButton) {
        view.endEditing(true)
        let picker = BRDatePickerView(pickerMode: .YM)
        picker?.resultBlock = { (date, str) in
            self.titleLab.text = date?.toString("yyyy-MM")
            self.vm.month = date?.toString("yyyy-MM") ?? ""
            self.tableView.mj_header?.beginRefreshing()
        }
        picker?.show()
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

extension HTBillViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.billModel.acountDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTBillCell", for: indexPath) as! HTBillCell
        cell.model = vm.billModel.acountDetailList[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
}
