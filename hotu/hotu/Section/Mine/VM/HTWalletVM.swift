
//
//  HTWalletVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTWalletVM: NSObject {
    
    var billModel = HTBillSuperModel()
    
    var month = ""
    
    var dataSource = [HTItemModel]()
    
    var openBankModel = HTItemModel()
    
    var bank_account = ""
    
    var bank_phone_no = ""
    
    var valid_code = ""
    
    var balance = ""
    
    var bankList = [HTBankModel]()
    
    var bankModel = HTBankModel()
    
    func requestAddBank(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["bank_name": openBankModel.itemName,
                      "bank_logo":openBankModel.itemCode,
                      "bank_code":openBankModel.ext,
                      "bank_account":bank_account,
                      "bank_phone_no":bank_phone_no,
                      "valid_code":valid_code]
        FYNetWork.request(ADD_BANK, params: params).responseJSON { (response: HTBaseModel<[HTItemModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if bank_account.isEmpty {
            Toast("请填写银行卡号")
            return false
        }
        if openBankModel.id.isEmpty {
            Toast("请选择银行")
            return false
        }
        if !bank_phone_no.isPhone() {
            Toast("请正确填写手机号")
            return false
        }
        if valid_code.isEmpty {
            Toast("请填写验证码")
            return false
        }
        return true
    }
    
    func requestGetBalance(complete: @escaping(Bool)->Void) {
        FYNetWork.request(GET_BALANCE, method: .get, params: [:]).responseJSON { (json) in
            self.balance = json["data"]["avaliableAmount"].stringValue
            complete(true)
        }
    }
    
    func requestBankList(complete: @escaping(Bool)->Void) {
        FYNetWork.request(BANK_LIST, params: [:], isLoading: false).responseJSON { (response: HTBaseModel<[HTBankModel]>) in
            if let d = response.data {
                self.bankList = d
            }
            complete(true)
        }.failure { (error) in
            complete(true)
        }
    }
    
    func requestBillList(complete: @escaping(Bool)->Void) {
        var api = ""
        if HTUserInfo.share.role == .club {
            api = BILL_MANAGER
        } else {
            api = BILL_CUSTOMER
        }
        let params = ["type": "0", "year_month":month]
        FYNetWork.request(api, params: params, isLoading: false).responseJSON { (response: HTBaseModel<HTBillSuperModel>) in
            if let d = response.data {
                self.billModel = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestCash(_ cash: String, complete: @escaping(Bool)->Void) {
        if let cashDouble = Double(cash),
            cashDouble <= 0 {
            Toast("提现金额必须大于0")
            return
        }
        let params = ["bankCradId": bankModel.id, "amount": cash]
        FYNetWork.request(CASH_ACTION, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
}
