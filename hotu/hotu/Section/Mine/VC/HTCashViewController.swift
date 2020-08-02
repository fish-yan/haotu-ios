//
//  HTCashViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCashViewController: UIViewController {

    @IBOutlet weak var ablePriceLab: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var bankLab: UILabel!
    @IBOutlet weak var logoImgV: UIImageView!
        
    var vm = HTWalletVM()
    
    var complete: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let f = vm.bankList.first {
            vm.bankModel = f
        }
        configView()
    }
    
    private func configView() {
        priceTF.becomeFirstResponder()
        logoImgV.sd_setImage(with: URL(string: vm.bankModel.bank_logo), completed: nil)
        let bankNum = String(vm.bankModel.bank_account.suffix(4))
        bankLab.text = "尾号为\(bankNum)的储蓄卡"
        ablePriceLab.text = "可提现金额：\(vm.balance)元"
    }

    @IBAction func cashAction(_ sender: UIButton) {
        view.endEditing(true)
        vm.requestCash(priceTF.text ?? "0") { (success) in
            Toast("提现成功")
            if let c = self.complete {
                c(true)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTBankCardList" {
            let vc = segue.destination as! HTBankCardListViewController
            vc.complete = { model in
                self.vm.bankModel = model
                self.configView()
            }
        }
    }

}
