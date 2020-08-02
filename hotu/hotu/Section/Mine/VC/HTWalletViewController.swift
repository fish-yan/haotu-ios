//
//  HTWalletViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTWalletViewController: UIViewController {

    @IBOutlet weak var balanceLab: UILabel!
    @IBOutlet weak var tixianBtn: UIButton!
    
    var vm = HTWalletVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        tixianBtn.isHidden = HTUserInfo.share.role != .club
    }
    
    func request() {
        vm.requestGetBalance { [weak self] (success) in
            self?.balanceLab.text = self?.vm.balance
        }
    }
    
    @IBAction func tixianAction(_ sender: UIButton) {
        if Double(vm.balance) ?? 0 <= 0 {
            Toast("无可提现金额")
            return
        }
        showHUD()
        vm.requestBankList { [weak self] (success) in
            if self?.vm.bankList.isEmpty ?? true {
                Toast("请先添加银行卡")
            } else {
                self?.performSegue(withIdentifier: "HTCash", sender: nil)
            }
            hidHUD()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTCash" {
            let vc = segue.destination as! HTCashViewController
            vc.vm = vm
            vc.complete = { success in
                self.request()
            }
        }
    }

}

