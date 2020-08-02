//
//  HTUserInfo.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/25.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import RongIMKit


enum HTRoleType: String {
    case visitor = "0" // 未登录（自定义）
    case normal = "1" // 普通
    case club = "2" // 群主
    case coach = "3" // 教练
    case merc = "4" // 商户
    case anchor = "5" // 主播
    case all = "-1" // 测试权限
}

@objcMembers
class HTUserInfo: NSObject, HandyJSON {
        
    static let share = HTUserInfo()
    
    private let userInfoKey = "userInfoKey"
    
    var rcInfo = RCUserInfo()
    
    var tokenId: String {
        set{
            set(newValue, forKey: "tokenId")
        }
        get{
            return object(forKey: "tokenId") ?? ""
        }
    }
    
    var rcToken: String {
        set{
            set(newValue, forKey: "rcToken")
        }
        get{
            return object(forKey: "rcToken") ?? ""
        }
    }
    
    var wxToken: String {
        set{
            set(newValue, forKey: "wxToken")
        }
        get{
            return object(forKey: "wxToken") ?? ""
        }
    }
    
    var wxRefreshToken: String {
        set{
            set(newValue, forKey: "wxRefreshToken")
        }
        get{
            return object(forKey: "wxRefreshToken") ?? ""
        }
    }
    
    var wxOpenId: String {
        set{
            set(newValue, forKey: "wxOpenId")
        }
        get{
            return object(forKey: "wxOpenId") ?? ""
        }
    }
    
    var role: HTRoleType {
        set{
            set(newValue.rawValue, forKey: "roleCode")
        }
        get{
            let raw = object(forKey: "roleCode") ?? "0"
            return HTRoleType(rawValue: raw) ?? .visitor
        }
    }
    
    var userId: String {
        set{
            set(newValue, forKey: "userId")
        }
        get{
            return object(forKey: "userId") ?? ""
        }
    }
    
    var userName: String {
        set{
            set(newValue, forKey: "userName")
        }
        get{
            return object(forKey: "userName") ?? ""
        }
    }
    
    var headerImg: String {
        set{
            set(newValue, forKey: "headerImg")
        }
        get{
            return object(forKey: "headerImg") ?? ""
        }
    }
    
    var sex: String {
        set{
            set(newValue, forKey: "sex")
        }
        get{
            return object(forKey: "sex") ?? ""
        }
    }
    
    var tel: String {
        set{
            set(newValue, forKey: "tel")
        }
        get{
            return object(forKey: "tel") ?? ""
        }
    }
    
    var versionCode: String {
        set{
            set(newValue, forKey: "versionCode")
        }
        get{
            return object(forKey: "versionCode") ?? "0"
        }
    }
    
    var province: String {
        set{
            set(newValue, forKey: "province")
        }
        get{
            return object(forKey: "province") ?? ""
        }
    }
    
    var city: String {
        set{
            set(newValue, forKey: "city")
        }
        get{
            return object(forKey: "city") ?? ""
        }
    }
    
    var area: String {
        set{
            set(newValue, forKey: "area")
        }
        get{
            return object(forKey: "area") ?? ""
        }
    }
    
    var address: String {
        set{
            set(newValue, forKey: "address")
        }
        get{
            return object(forKey: "address") ?? ""
        }
    }
    
    var latitude: Double {
        set{
            set("\(newValue)", forKey: "latitude")
        }
        get{
            return Double(object(forKey: "latitude") ?? "0") ?? 0.0
        }
    }
    
    var longitude: Double {
        set{
            set("\(newValue)", forKey: "longitude")
        }
        get{
            return Double(object(forKey: "longitude") ?? "0") ?? 0.0
        }
    }
    
    var account_amount: String {
        set{
            set(newValue, forKey: "account_amount")
        }
        get{
            return object(forKey: "account_amount") ?? ""
        }
    }
    
    var measure_count: String {
        set{
            set(newValue, forKey: "measure_count")
        }
        get{
            return object(forKey: "measure_count") ?? ""
        }
    }
    
    var activity_count: String {
        set{
            set(newValue, forKey: "activity_count")
        }
        get{
            return object(forKey: "activity_count") ?? ""
        }
    }
    
    var realName: String {
        set{
            set(newValue, forKey: "realName")
        }
        get{
            return object(forKey: "realName") ?? ""
        }
    }
    
    var idcard: String {
        set{
            set(newValue, forKey: "idcard")
        }
        get{
            return object(forKey: "idcard") ?? ""
        }
    }
    
    var birthday: String {
        set{
            set(newValue, forKey: "birthday")
        }
        get{
            return object(forKey: "birthday") ?? ""
        }
    }
    
    var isReal: Bool {
        set{
            set(newValue ? "1" : "0", forKey: "isReal")
        }
        get{
            let v = object(forKey: "isReal") ?? "0"
            return v == "1"
        }
    }
    
    /// 更新User
    func updateUser(with json: JSON) {
        if let token = json["token_sys"].string {
            HTUserInfo.share.tokenId = token
        }
        if let userId = json["user_id"].string {
            HTUserInfo.share.userId = userId
        }
        if let userId = json["id"].string {
            HTUserInfo.share.userId = userId
        }
        if let nickName = json["nick_name"].string {
            HTUserInfo.share.userName = nickName
        }
        if let userLogo = json["img_url"].string {
            HTUserInfo.share.headerImg = userLogo
        }
        if let userLogo = json["user_logo"].string {
            HTUserInfo.share.headerImg = userLogo
        }
        if let sex = json["sex"].string {
            HTUserInfo.share.sex = sex
        }
        if let tel = json["phoneNO"].string {
            HTUserInfo.share.tel = tel
        }
        if let rcToken = json["token_third"].string {
            HTUserInfo.share.rcToken = rcToken
        }
        if let roleCode = json["role_code"].string {
            HTUserInfo.share.role = HTRoleType(rawValue: roleCode) ?? .visitor
        }
        if let roleCode = json["roleCode"].string {
            HTUserInfo.share.role = HTRoleType(rawValue: roleCode) ?? .visitor
        }
        if let name = json["name"].string {
            HTUserInfo.share.realName = name
        }
        if let idcard = json["idNo"].string {
            HTUserInfo.share.idcard = idcard
        }
        if let isreal = json["isRealName"].string {
            HTUserInfo.share.isReal = isreal == "1"
        }
    }
    
    public func clearUserInfo() {
        UserDefaults.standard.removeObject(forKey: userInfoKey)
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HTMainViewController")
        NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.visitor], userInfo: nil)
    }
    
    private func set(_ value: String?, forKey: String) {
        var userInfo = [String: String]()
        if let dict = UserDefaults.standard.object(forKey: userInfoKey) as? [String: String] {
            userInfo = dict
        }
        if let v = value {
            userInfo.updateValue(v, forKey: forKey)
        }
        UserDefaults.standard.set(userInfo, forKey: userInfoKey)
    }
    
    private func object(forKey: String) -> String? {
        if let dict = UserDefaults.standard.object(forKey: userInfoKey) as? [String: String] {
            return dict[forKey]
        }
        return nil
    }
        
    required override init() {}
}
