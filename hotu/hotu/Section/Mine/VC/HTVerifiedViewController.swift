//
//  HTVerifiedViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVerifiedViewController: UIViewController {

    @IBOutlet weak var idcardNumTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var complete: ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idcardNumTF.text = HTUserInfo.share.idcard
        nameTF.text = HTUserInfo.share.realName
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        requestVerified { (success) in
            
            if let c = self.complete {
                c(true)
                if var vcs = self.navigationController?.viewControllers {
                    vcs.removeAll(where: {$0 == self})
                    self.navigationController?.viewControllers = vcs
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            NotificationCenter.default.post(name: .HTUserInfoChanged, object: nil)
        }
    }
    @IBAction func userProAction(_ sender: UIButton) {
        view.endEditing(true)
        FYWebViewController.open(HTML_USER_PRO)
    }
    
    @IBAction func privateAction(_ sender: UIButton) {
        view.endEditing(true)
        FYWebViewController.open(HTML_PRIVATE)
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

extension HTVerifiedViewController {
    func requestVerified(complete: @escaping(Bool)->Void) {
        guard let name = nameTF.text,
            name.count >= 2 else {
                Toast("请输入真实姓名")
                return
        }
        guard let idcard = idcardNumTF.text,
            idcard.isIDCard() else {
                Toast("请输入正确的身份证号码")
                return
        }
        let params = ["idNo": idcardNumTF.text!, "name":nameTF.text!]
        FYNetWork.request(USER_VERIFITY, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("认证成功") {
                complete(true)
            }
        }
    }
}
