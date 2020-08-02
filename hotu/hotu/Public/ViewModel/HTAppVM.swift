//
//  HTAppVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/25.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import StoreKit
import AFNetworking

@objcMembers
class HTAppVM: NSObject {
    static let share = HTAppVM()
    
    let api = API
    
    /// 检查更新
    func checkUpdate() {
        guard let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
            else { return }
        let ver = Int(version.replacingOccurrences(of: ".", with: "")) ?? 0
        request("https://itunes.apple.com/cn/lookup?id=\(APP_ID)", method: .get, parameters: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let result = json["results"].arrayValue.first {
                    let appStoreVersion = result["version"].stringValue
                    let appVer = Int(appStoreVersion.replacingOccurrences(of: ".", with: "")) ?? 0
                    if ver < appVer {
                        let params = ["versionCode": version]
                        FYNetWork.request(CHECK_UPDATE, params: params).responseJSON{ json in
                            var focus = json["data"]["versionType"].stringValue == "1"
                            let note = json["data"]["versionNote"].stringValue
                            if appVer == "150" {
                                focus = true
                            }
                            self.updateAlert(note,focus: focus)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateAlert(_ msg: String, focus: Bool = false) {
        var alert: FYAlertController!
        if focus {
            alert = FYAlertController(title: "有新版本了", msg: msg, commit: "升级")
        } else {
            alert = FYAlertController(title: "有新版本了", msg: msg, commit: "升级", cancel: "下次再说")
        }
        alert.action(commit: {
            let storeVC = SKStoreProductViewController()
            storeVC.delegate = self
            storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:APP_ID], completionBlock: nil)
            if let vc = visibleViewController {
                storeVC.modalPresentationStyle = .fullScreen;
                storeVC.modalTransitionStyle = .crossDissolve
                vc.present(storeVC, animated: true, completion: nil)
            } else {
                let url = URL(string: "https://itunes.apple.com/app/id\(APP_ID)")!
                UIApplication.shared.openURL(url)
            }
            if !focus {
                alert.dismiss(animated: true, completion: nil)
            }
        })

        if let vc = visibleViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func requestUserInfo(complete: @escaping(Bool)->Void) {
        FYNetWork.request(USER_INFO, params: [:], isLoading: false).responseJSON { (json) in
            HTUserInfo.share.updateUser(with: json["data"])
            complete(true)
        }
    }
    
    func requestGetCode(tel: String ,complete: @escaping(Bool)->Void) {
        guard tel.isPhone() else {
                Toast("请输入正确的手机号码")
                return
        }
        let params = ["phone_no": tel]
        FYNetWork.request(SEND_MSG_CODE, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    
    func requestItemList(code: String, complete: @escaping([HTItemModel]?)->Void) {
        let params = ["key": code]
        FYNetWork.request(DICT_BY_KEY, params: params).responseJSON { (response: HTBaseModel<[HTItemModel]>) in
            complete(response.data)
        }
    }
    
    func uploadImage(_ image: UIImage, isZoom: Bool = false, isLogo: Bool = false, isLive: Bool = false, complete: @escaping ((String?)->Void)) {
        var img = image
        if isLogo {
            let width = Swift.min(image.size.width, image.size.height)
            if let temp = image.clipImage(CGSize(width: width, height: width)) {
                img = temp
            }
        }
        HTRequest.uploadImage(img, isZoom: isZoom, isLogo:isLogo, isLive: isLive, complete: complete)
    }
    
    func requestAd(code: String, isLoading: Bool = true, complete: @escaping([HTItemModel]?)->Void) {
        let params = ["key": code]
        FYNetWork.request(AD_BY_KEY, params: params, isLoading: isLoading).responseJSON { (response: HTBaseModel<[HTItemModel]>) in
            complete(response.data)
        }.failure { (error) in
            complete(nil)
        }
    }
    
    func requestShareUrl(_ id: String, type: String, complete: @escaping((HTShareModel)->Void)) {
        FYNetWork.request("topic/share/getShareMessage", method:.get, params: ["id":id, "type":type]).responseJSON { (response: HTBaseModel<HTShareModel>) in
            complete(response.data ?? HTShareModel())
        }
    }
}

extension HTAppVM: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
