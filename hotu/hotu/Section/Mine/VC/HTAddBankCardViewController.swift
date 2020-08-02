//
//  HTAddBankCardViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAddBankCardViewController: UIViewController {

    @IBOutlet weak var bankNmTF: UITextField!
    
    @IBOutlet weak var codeTF: UITextField!
    
    var vm = HTWalletVM()
    
    var complete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func bankCardNumChanged(_ sender: UITextField) {
        vm.bank_account = sender.text ?? ""
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
//        vm.name = sender.text ?? ""
    }
    
    @IBAction func idcardChanged(_ sender: UITextField) {
//        vm.idcard = sender.text ?? ""
    }
    
    @IBAction func telChanged(_ sender: UITextField) {
        vm.bank_phone_no = sender.text ?? ""
    }
    
    @IBAction func codeChanged(_ sender: UITextField) {
        vm.valid_code = sender.text ?? ""
    }
    
    @IBAction func cutdownAction(_ sender: HTCutdownBtn) {
        HTAppVM.share.requestGetCode(tel: vm.bank_phone_no) { (success) in
            sender.cutDown()
            self.codeTF.becomeFirstResponder()
        }
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        vm.requestAddBank { (success) in
            self.navigationController?.popViewController(animated: true)
            if let c = self.complete {
                c()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTItemList" {
            let vc = segue.destination as! HTItemListViewController
            vc.code = "BANK_CODE"
            vc.complete = { item in
                self.vm.openBankModel = item
                self.bankNmTF.text = item.itemName
            }
        }
    }

    
}
