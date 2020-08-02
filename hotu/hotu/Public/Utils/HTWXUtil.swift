//
//  HTWXPayUtil.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/11.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire
import SwiftyJSON

class HTWXUtil: NSObject, WXApiDelegate {
    
    static let share = HTWXUtil()
    
    private var loginComplete: ((HTWXUserInfoModel)->Void)?
    
    private var payComplete:  ((Bool)->Void)?
    
    private var loginModel = HTWXLoginResult()
            
    func pay(with model: HTWXPayModel, complete: @escaping(Bool)->Void) {
        guard WXApi.isWXAppInstalled() else {
            Toast("该设备未安装微信")
            return
        }
        WXApi.registerApp(WX_KEY)
        let request = PayReq()
        request.partnerId = model.partnerid
        request.prepayId = model.prepayid
        request.package = model.packageMsg
        request.nonceStr = model.nonceStr
        request.timeStamp = model.timeStamp
        request.sign = model.sign
        WXApi.send(request)
        payComplete = complete
    }
    
    func login(complete: @escaping(HTWXUserInfoModel)->Void) {
        guard WXApi.isWXAppInstalled() else {
            Toast("该设备未安装微信")
            return
        }
        let key = "wx82cdaef96e37dbeb"
        WXApi.registerApp(key)
        let request = SendAuthReq()
        request.state = "wx_auto_state"
        request.scope = "snsapi_userinfo"
        WXApi.send(request)
        loginComplete = complete
    }

    func onResp(_ resp: BaseResp) {
        if let res = resp as? PayResp {
            switch res.errCode {
            case 0:
                if let p = payComplete {
                    p(true)
                }
                print("微信支付成功")
            default:
                if let p = payComplete {
                    p(false)
                }
                print("微信支付失败")
            }
        }
        if let res = resp as? SendAuthResp {
            switch res.errCode {
            case 0:
                requestWxToken(code: res.code ?? "")
                print("微信登录成功")
            default:
                print("微信登录失败")
            }
        }
    }
    
    func requestWxToken(code: String) {
        let key = "wx82cdaef96e37dbeb"
        let sec = "ce148969d9ea9a78f2ad48189432ab18"
        let params = ["appid": key, "secret":sec, "code":code, "grant_type":"authorization_code"]
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token"
        showHUD()
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            WXApi.registerApp(WX_KEY)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let model = HTWXLoginResult.deserialize(from: json.dictionaryObject) {
                    if model.errcode != "0" {
                        hidHUD()
                        Toast(model.errmsg)
                        return
                    }
                    self.loginModel = model
                    HTUserInfo.share.wxToken = model.access_token
                    HTUserInfo.share.wxRefreshToken = model.refresh_token
                    self.requestWxUserInfo()
                    
                }
            case .failure(let error):
                hidHUD()
                print(error)
            }
        }
    }
        
    func requestWxUserInfo() {
        let params = ["access_token": loginModel.access_token, "openid":loginModel.openid]
        let url = "https://api.weixin.qq.com/sns/userinfo"
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            hidHUD()
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let model = HTWXUserInfoModel.deserialize(from: json.dictionaryObject) {
                    if model.errcode != "0" {
                        Toast(model.errmsg)
                        return
                    }
                    if model.sex.isEmpty {
                        model.sex = "1"
                    }
                    if model.nickname.isEmpty {
                        model.nickname = "hotu123"
                    }
                    if model.headimgurl.isEmpty {
                        model.headimgurl = "http://47.100.223.153:8888/group1/M00/00/00/rBNsuF1ThzSAA4s9AAAsB0k_Pwk100.png"
                    }
                    if let complete = self.loginComplete {
                        complete(model)
                    }
                }
            case .failure(let error):
                print(error)
            }            
            
        }
    }
        
}

class HTWXLoginResult: NSObject, HandyJSON {
    var access_token = ""
    var expires_in = ""
    var refresh_token = ""
    var openid = ""
    var scope = ""
    var unionid = ""
    var errcode = "0"
    var errmsg = ""
    required override init(){}
}

class HTWXUserInfoModel: NSObject, HandyJSON {
    var openid = ""
    var nickname = ""
    var sex = "1"
    var province = ""
    var city = ""
    var country = ""
    var headimgurl = ""
    var privilege = ""
    var unionid = ""
    var errcode = "0"
    var errmsg = ""
    
    required override init(){}
}

