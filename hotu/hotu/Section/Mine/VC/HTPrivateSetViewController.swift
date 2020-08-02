//
//  HTPrivateSetViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPrivateSetViewController: UIViewController {

    @IBOutlet weak var recommendSwitch: UISwitch!
    
    @IBOutlet weak var agreeContactSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetCanVisitContact { (success) in
            self.agreeContactSwitch.setOn(success, animated: false)
        }
    }
    
    @IBAction func canVisitContactAction(_ sender: UISwitch) {
        sender.isEnabled = false
        requestCanVisitContact(sender.isOn) { (success) in
            sender.isEnabled = true
            if !success {
                sender.isOn = !sender.isOn
                if sender.isOn {
                    Toast("关闭失败")
                } else {
                    Toast("打开失败")
                }
            }
        }
    }
    
    @IBAction func firstSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            mainVC?.configView()
        } else {
            NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.normal])
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

// MARK: - request
extension HTPrivateSetViewController {
    
    func requestGetCanVisitContact(complete: @escaping(Bool)->Void) {
        FYNetWork.request(GET_VISIT_CONTACT, params: [:], isLoading: false).responseJSON { (json) in
            let isAgree = json["data"]["isAcceptMailList"].stringValue
            complete(isAgree == "1")
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestCanVisitContact(_ isAgree: Bool, complete: @escaping(Bool)->Void) {
        FYNetWork.request(SET_VISIT_CONTACT, params: ["isAcceptMailList":isAgree ? "1":"0"], isLoading: false).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
}
