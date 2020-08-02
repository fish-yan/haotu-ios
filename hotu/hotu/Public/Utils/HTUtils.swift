//
//  HTUtils.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import SwiftyJSON

class HTUtils: NSObject {

    static let share = HTUtils()
    
    var viewControllerChanged: ((UIViewController)->Void)?
    
    func vcChanged(_ vc: UIViewController) {
        if let vcChange = viewControllerChanged {
            vcChange(vc)
        }
    }
    
    func configAppInfo() {
        HTRCUtils.share.configRCInfo()
        HTAppVM.share.requestUserInfo { (success) in
            
        }
        NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.normal], userInfo: nil)
    }
    
    func checkLogin(complete:@escaping ()->Void) {
        if HTUserInfo.share.role == .visitor {
            HTLoginViewController.login { (success) in
                complete()
            }
        } else {
            complete()
        }
    }
    
    func checkVitified(complete:@escaping ()->Void) {
        if HTUserInfo.share.isReal {
            complete()
        } else {
            Toast("请先进行实名认证")
            let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTVerifiedViewController") as! HTVerifiedViewController
            vc.complete = { success in
                complete()
            }
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func transformJSONStr(_ dict: [String: String]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict,options: .prettyPrinted)
            if var jsonStr = String(data: jsonData, encoding: .utf8) {
                jsonStr = jsonStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                jsonStr = jsonStr.replacingOccurrences(of: "\n", with: "")
                return jsonStr
            } else {
                    print("PML-转换 json 失败")
            }
        } catch let error {
            print(error)
                print("PML-转换 json 失败")
        }
        return ""
    }
    
    func transformJSONObject(_ str: String) -> [String: Any] {
        do {
            if let jsonData = str.data(using: .utf8),
                let d = try JSONSerialization.jsonObject(with: jsonData, options: [.mutableContainers, .allowFragments, .fragmentsAllowed, .mutableLeaves]) as? [String: Any] {
                return d
            }
        } catch let error {
            print(error)
        }
        return [String: Any]()
    }
    
    func getEndTime(_ duration: Int) -> String {
        var str = ""
        let d = duration / (3600 * 24)
        if d > 0 {
            str += "\(d)天"
        }
        let h = duration / 3600
        if h > 0 || str.count != 0 {
            str += "\(h)小时"
        }
        let m = (duration % 3600) / 60
        if m > 0 || str.count != 0 {
            str += "\(m)分钟"
        }
        let s = duration % 60
        if s > 0 || str.count != 0 {
            str += "\(s)秒"
        }
        return str
    }
}
