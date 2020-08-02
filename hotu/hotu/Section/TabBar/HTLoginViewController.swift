
//
//  HTLaunchViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/12.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLoginViewController: UIViewController {

    @IBOutlet weak var wxLoginBtn: UIButton!
    @IBOutlet weak var telTF: UITextField!
    
    @IBOutlet weak var codeTF: UITextField!
    
    private var complete: ((Bool)->Void)?
    
    var wxModel = HTWXUserInfoModel()
    
    var isBind = false
    
    static func login(complete: @escaping (Bool)->Void) {
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HTLoginViewController") as! UINavigationController
        if let vc = nav.topViewController as? HTLoginViewController {
            vc.complete = complete
        }
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .coverVertical
        visibleViewController?.present(nav, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attr = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x9D9D9D)]
        telTF.attributedPlaceholder = NSAttributedString(string: "输入手机号码", attributes: attr)
        codeTF.attributedPlaceholder = NSAttributedString(string: "输入验证码", attributes: attr)
        wxLoginBtn.isHidden = !WXApi.isWXAppInstalled()
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        view.endEditing(true)
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func sendCodeAction(_ sender: HTCutdownBtn) {
        guard let tel = telTF.text,
            tel.isPhone() else {
                Toast("请正确填写手机号码")
                return
        }
        HTAppVM.share.requestGetCode(tel: tel) { (success) in
            sender.cutDown()
            self.codeTF.becomeFirstResponder()
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        view.endEditing(true)
        requestLogin { (success) in
            HTUtils.share.configAppInfo()
            self.dismiss(animated: true) {
                if let com = self.complete {
                    com(true)
                }
            }
        }
    }
    
    @IBAction func wxLoginAction(_ sender: UIButton) {
        view.endEditing(true)
        HTWXUtil.share.login { (model) in
            self.wxModel = model
            self.requestIsBindWx { (success) in
                if self.isBind {
                    HTUtils.share.configAppInfo()
                    self.dismiss(animated: true) {
                        if let com = self.complete {
                            com(true)
                        }
                    }
                } else {
                   self.performSegue(withIdentifier: "HTLoginBindTel", sender: model)
                }
            }
            
        }
    }
    @IBAction func userProAction(_ sender: UIButton) {
        view.endEditing(true)
        FYWebViewController.open(HTML_USER_PRO)
    }
    
    @IBAction func privateProAction(_ sender: UIButton) {
        view.endEditing(true)
        FYWebViewController.open(HTML_PRIVATE)
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTLoginBindTel" {
            let vc = segue.destination as! HTLoginBindTelViewController
            if let model = sender as? HTWXUserInfoModel {
                vc.wxUserInfo = model
            }
            vc.complete = { success in
                HTUtils.share.configAppInfo()
                self.dismiss(animated: true) {
                    if let com = self.complete {
                        com(true)
                    }
                }
            }
        }
    }

}

extension HTLoginViewController {
    func requestLogin(complete: @escaping(Bool)->Void) {
        guard let tel = telTF.text,
            tel.isPhone() else {
                Toast("请正确填写手机号码")
                return
        }
        guard let code = codeTF.text else {
                Toast("请填写验证码")
                return
        }
        let params = ["phone_no": tel, "validate_code": code]
        FYNetWork.request(LOGIN, params: params).responseJSON { (json) in
            HTUserInfo.share.updateUser(with: json["data"])
            complete(true)
        }
    }
    
    func requestIsBindWx(complete: @escaping(Bool)->Void) {
        let params = ["loginType": "1", "openId": wxModel.openid]
        FYNetWork.request(IS_BIND_WX, params: params).responseJSON { (json) in
            self.isBind = json["data"]["isBinding"].stringValue == "1"
            if self.isBind {
                HTUserInfo.share.updateUser(with: json["data"])
            }
            complete(true)
        }
    }
}
