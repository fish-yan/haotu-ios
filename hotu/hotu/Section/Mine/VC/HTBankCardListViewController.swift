//
//  HTBankCardListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTBankCardListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vm = HTWalletVM()
    
    var complete: ((HTBankModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    private func request() {
        vm.requestBankList { (success) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        HTUtils.share.checkVitified {
            self.performSegue(withIdentifier: "HTAddBankCard", sender: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTAddBankCard" {
            let vc = segue.destination as! HTAddBankCardViewController
            vc.complete = {
                self.tableView.mj_header?.beginRefreshing()
            }
        }
    }

}

extension HTBankCardListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTBankListCell", for: indexPath) as! HTBankListCell
        cell.model = vm.bankList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let c = complete {
            c(vm.bankList[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
}
