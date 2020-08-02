//
//  HTLoginBindTelViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/13.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLoginBindTelViewController: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var telTF: UITextField!
    
    var wxUserInfo = HTWXUserInfoModel()
    
    var complete: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
  
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        requestBindTel { (success) in
            if let com = self.complete {
                com(true)
            }
        }
    }
    
    @IBAction func sendCodeAction(_ sender: HTCutdownBtn) {
        view.endEditing(true)
        guard let tel = telTF.text,
            tel.isPhone() else {
                Toast("请输入正确的手机号码")
                return
        }
        HTAppVM.share.requestGetCode(tel: tel) { (success) in
            sender.cutDown()
            self.codeTF.becomeFirstResponder()
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

extension HTLoginBindTelViewController {
    func requestBindTel(complete: @escaping(Bool)->Void) {
        guard let tel = telTF.text,
            tel.isPhone() else {
                Toast("请输入正确的手机号码")
                return
        }
        guard let code = codeTF.text,
            !code.isEmpty else {
                Toast("请输入验证码")
                return
        }
        
        let params = ["phone_no": tel,
                      "validate_code":code,
                      "sex": wxUserInfo.sex,
                      "loginType": "1",
                      "openId": wxUserInfo.openid,
                      "nickName": wxUserInfo.nickname,
                      "iconUrl":wxUserInfo.headimgurl]
        FYNetWork.request(THRID_UPDATE_USER_INFO, params: params).responseJSON { (json) in
            HTUserInfo.share.updateUser(with: json["data"])
            complete(true)
        }
    }
}
