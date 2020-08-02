//
//  HTBindPhoneViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTBindPhoneViewController: UIViewController {
    
    @IBOutlet weak var oldTelTF: UITextField!
    @IBOutlet weak var newTelTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        oldTelTF.text = HTUserInfo.share.tel
    }
    
    @IBAction func cutDownAction(_ sender: HTCutdownBtn) {
        view.endEditing(true)
        guard let newTel = newTelTF.text,
            newTel.isPhone() else {
                Toast("请输入正确的手机号码")
                return
        }
        HTAppVM.share.requestGetCode(tel: newTel) { (success) in
            sender.cutDown()
            self.codeTF.becomeFirstResponder()
        }
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        requestUpdateUserInfo { (success) in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .HTUserInfoChanged, object: nil)
        }
    }
    
    func requestUpdateUserInfo(complete: @escaping(Bool)->Void) {
        guard let tel = newTelTF.text,
            tel.isPhone()  else {
                Toast("请填写名字")
                return
        }
        guard let code = codeTF.text,
            !code.isEmpty else {
                Toast("请填写验证码")
                return
        }
        
        let params = ["phoneNo": tel,
                      "validCode":code]
        FYNetWork.request(EDIT_USER_INFO, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("修改成功")
            complete(true)
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

