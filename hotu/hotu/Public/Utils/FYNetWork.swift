//
//  FYNetWork.swift
//  PartnerApp
//
//  Created by Yan on 2018/7/9.
//  Copyright © 2018年 Yan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import HandyJSON

open class FYNetWork: NSObject {
    
    public static let share = FYNetWork()
    static let sessionManager = { () -> SessionManager in
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "testpartner.starpos.com.cn": .disableEvaluation
        ]
        
        let sessionManager = Alamofire.SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return sessionManager
    }()
    
    public var config = FYConfigure()
    
    fileprivate override init() {
        super.init()
    }
    
    fileprivate var url = ""
    
    fileprivate var params = [String: String]()
    
    fileprivate var dateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateStr = formatter.string(from: Date(timeInterval: -3 * 3600, since: Date())) // 每日3点之后刷新数据
        return dateStr
    }
    
    fileprivate let currentV = visibleViewController?.view
    
    fileprivate let localCache = "localCache"
    
    fileprivate var networks = [FYNetWork]()
    
    fileprivate var complete:((_ value: JSON)->Void)?
        
    fileprivate var failure:((_ error: FYError)->Void)?
    
    fileprivate var isCache = false
    
    fileprivate var isLoading = true
    
    fileprivate var isUpdateCache = false
    
    fileprivate var shouldToast = true
    
    private var specialAction:((()->Void))?
    
    private var specialCode = [String]()
    
    public var setParams:(()->[String: String])?
}

extension FYNetWork {
    
    @discardableResult
    public static func request(_ urlStr: String, method: HTTPMethod = .post, params: [String: String] = [:], isLoading: Bool = true, encoding:ParameterEncoding = URLEncoding.default) -> FYNetWork {
        var url = urlStr
        if !url.contains("http") {
            url = API + urlStr
        }
        let isCache: Bool = false, isUpdateCache: Bool = false
        var parameters = params
        if let setParams = FYNetWork.share.setParams {
            parameters.merge(setParams(), uniquingKeysWith: +)
        }
        let network = FYNetWork()
        network.url = url
        network.params = parameters
        network.isCache = isCache
        network.isLoading = isLoading
        network.isUpdateCache = isUpdateCache
        print("====\(url)\n\(JSON(parameters))")
        FYNetWork.share.networks.append(network)
        if isCache,
            let result = network.loadCache() {
            // 必须加延迟，否则mjrefresh不会停止刷新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                if let complete = network.complete {
                    complete(result)
                    if !isUpdateCache {
                        FYNetWork.share.networks.remove(at: FYNetWork.share.networks.firstIndex(of: network)!)
                    }
                    
                }
            }
            network.shouldToast = false
            if !isUpdateCache {
                return network
            }
        }
        if isLoading && network.shouldToast { showHUD(on: network.currentV) }
        FYNetWork.sessionManager.request(url, method: method, parameters: parameters, encoding: encoding).responseJSON { (response) in
            if isLoading  && network.shouldToast  { hidHUD() }
            switch response.result {
            case .success(let value):
                network.requestSuccess(value)
            case .failure(let e):
                let error = FYError(e.localizedDescription)
                network.requestFailure(error)
            }
        }
        return network
    }
    
    @discardableResult
    public func responseJSON<T>(complete: @escaping (_ value: HTBaseModel<T>)->Void) -> Self {
        responseJSON { (json) in
            if let model = HTBaseModel<T>.deserialize(from: json.dictionaryObject) {
                complete(model)
            } else {
                complete(HTBaseModel<T>())
            }
        }
        return self
    }
    
    @discardableResult
    public func responseJSON(complete: @escaping (_ value: JSON)->Void) -> Self {
        FYNetWork.share.networks.last?.complete = complete
        return self
    }
    
    @discardableResult
    public func failure(failure: @escaping (_ error: FYError)->Void) -> Self {
        FYNetWork.share.networks.last?.failure = failure
        return self
    }
    
    private func requestSuccess(_ value: Any) {
        let json = JSON(value)
        print("====\(self.url)\n\(json)")
        let repcode = json[FYNetWork.share.config.codeKey].stringValue
        let repMsg = json[FYNetWork.share.config.msgKey].stringValue
        if repcode == FYNetWork.share.config.successCodeValue {
            if let complete = complete {
                complete(json)
                if isCache {
                    saveCache(json)
                }
                FYNetWork.share.networks.remove(at: FYNetWork.share.networks.firstIndex(of: self)!)
            }
        } else {
            if shouldToast {Toast(repMsg, on: currentV)}
            if FYNetWork.share.specialCode.contains(repcode),
                let specialAction = FYNetWork.share.specialAction {
                specialAction()
            }
            let error = FYError(repMsg, errCode: repcode, errJson: json)
            if let failure = failure {
                failure(error)
                FYNetWork.share.networks.remove(at: FYNetWork.share.networks.firstIndex(of: self)!)
            }
        }
    }
    
    private func requestFailure(_ error: FYError) {
        if shouldToast {Toast(error.localizedDescription, on: currentV)}
        if let failure = failure {
            failure(error)
            FYNetWork.share.networks.remove(at: FYNetWork.share.networks.firstIndex(of: self)!)
        }
    }
    
    public func special(_ code: [String], action:@escaping(()->Void)) {
        FYNetWork.share.specialCode = code
        FYNetWork.share.specialAction = action
    }
    
    fileprivate func loadCache() -> JSON? {
        let key = url + transform(params: params)
        if let localDict = UserDefaults.standard.object(forKey: localCache) as? [String: Any],
            let lastDate = localDict["date"] as? String,
            let object = localDict[key] {
            if lastDate != dateStr {
                UserDefaults.standard.removeObject(forKey: localCache)
                return nil
            }
            return JSON(object)
        }
        return nil
    }
    
    fileprivate func saveCache(_ response: JSON) {
        let key = url + transform(params: params)
        var localDict = [String: Any]()
        if let tempDict = UserDefaults.standard.object(forKey: localCache) as? [String: Any] {
            localDict = tempDict
        }
        localDict.updateValue(dateStr, forKey: "date")
        localDict.updateValue(response.object, forKey: key)
        UserDefaults.standard.set(localDict, forKey: localCache)
    }
    
    fileprivate func transform(params: [String: String]) -> String {
        let keys = params.keys.sorted()
        var paramStr = ""
        paramStr += "{"
        for key in keys {
            let value = params[key] ?? ""
            paramStr += "\"\(key)\":\"\(value)\","
        }
        paramStr.removeLast()
        paramStr += "}"
        return paramStr
    }
    
}

public struct FYError: Error {
    public var localizedDescription: String
    public var code: String
    public var json: JSON!
    public init(_ description: String, errCode: String = "-1", errJson: JSON? = nil) {
        localizedDescription = description
        code = errCode
        json = errJson
    }
}

open class FYConfigure: NSObject {
    
    public var codeKey: String = "repCode"
    public var successCodeValue: String = "000000"
    public var msgKey: String = "repMsg"
    
    public var pubParams = [String: String]()
}


//获取当前活动的控制器
public var visibleViewController:UIViewController? {
    if UIApplication.shared.keyWindow?.rootViewController is HTMainViewController {
        return getVisibleViewControllerFrom(vc: UIApplication.shared.keyWindow?.rootViewController?.children.first)
    } else {
        return getVisibleViewControllerFrom(vc: UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.children.first)
    }
}

public func getVisibleViewControllerFrom(vc:UIViewController?) -> UIViewController? {
    if let nc = vc as? UINavigationController {
        return getVisibleViewControllerFrom(vc: nc.visibleViewController)
    } else if let tc = vc as? UITabBarController {
        return getVisibleViewControllerFrom(vc: tc.selectedViewController)
    } else {
        if let pvc = vc?.presentedViewController {
            return getVisibleViewControllerFrom(vc: pvc)
        } else {
            return vc
        }
    }
}

// MARK: - Loading
private let loading =  MBProgressHUD()

private var loadingCount = 0

public func showHUD(on currentV: UIView? = visibleViewController?.view) {
    guard let view = currentV else { return }
    view.addSubview(loading)
    view.bringSubviewToFront(loading)
    loading.animationType = .fade
    loading.mode = .indeterminate
    loading.show(animated: true)
    loadingCount += 1
}

public func hidHUD() {
    loadingCount -= 1
    loadingCount = max(0, loadingCount)
    if loadingCount == 0 {
        loading.hide(animated: true)
    }
}

private let toast = MBProgressHUD()

public func Toast(_ message: String, on currentV: UIView? = UIApplication.shared.keyWindow, complete:@escaping(()->Void) = {}) {
    guard let view = currentV else { return }
    toast.hide(animated: false)
    if message == "" {
        toast.hide(animated: false)
        return
    }
    view.addSubview(toast)
    view.bringSubviewToFront(toast)
    toast.animationType = .zoomOut
    toast.bezelView.color = UIColor.black
    toast.contentColor = UIColor.white
    toast.mode = .text
    toast.label.text = message
    toast.label.numberOfLines = 0
    toast.isUserInteractionEnabled = false
    toast.show(animated: true)
    toast.hide(animated: true, afterDelay: 2.0)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        complete()
    }
}
