//
//  HTActivityVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTActivityVM: NSObject {
    
    var pageIndex = 1
    
    /// 活动日期(多个日期的话以逗号分隔)格式为：yyyy-MM-dd HH:mm
    var activity_date = "\(Date().toString("yyyy-MM-dd")) 00:00:00"
    
    /// 活动类型：（0:活动、1、pk赛、2、赛事 99、全部）
    var type = "99"
    
    var payType = "1"
    
    var keyword = ""
    
    var isAgree = false
    
    var userId = ""
    
    var dataSource = [HTActivityModel]()
    
    var model = HTActivityModel()
    
    var shareUrl = ""
            
    func requestActivity(complete: @escaping(Bool)->Void) {
        var params = ["pageSize": "20",
                      "pageIndex":"\(pageIndex)",
            "activity_date":activity_date,
            "is_group_pk":type,
            "longitude":"\(HTUserInfo.share.longitude)",
            "latitude":"\(HTUserInfo.share.latitude)",]
        if !keyword.isEmpty {
            params["keyword"] = keyword
        }
        FYNetWork.request(ACTIVITY_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTActivityModel]>) in
            if self.pageIndex == 1 {
                self.dataSource = [HTActivityModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestActivityDetail(complete: @escaping(Bool)->Void) {
        let params = ["group_activity_id": model.activityId]
        FYNetWork.request(ACTIVITY_DETAIL, params: params).responseJSON { (response: HTBaseModel<HTActivityModel>) in
            if let d = response.data {
                let id = self.model.activityId
                self.model = d
                self.model.activityId = id
            }
            complete(true)
        }
    }
        
    func requestMyActivity(complete: @escaping((Bool)->Void)) {
        var params = ["logitude":"\(HTUserInfo.share.longitude)", "latitude":"\(HTUserInfo.share.latitude)", "type":type]
        if !userId.isEmpty {
            params["userId"] = userId
        }
        FYNetWork.request("activity/listMyCreateActivity", params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTActivityModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestMySignActivity(complete: @escaping((Bool)->Void)) {
        let params = ["pageIndex":"\(pageIndex)", "pageSize":"10", "longitude": "\(HTUserInfo.share.longitude)", "latitude":"\(HTUserInfo.share.latitude)"]
        FYNetWork.request("activity/listMySignUpActivitys", params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTActivityModel]>) in
            if self.pageIndex == 1 {
                self.dataSource = [HTActivityModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestShare(complete: @escaping(String)->Void) {
        let params = ["group_id": model.group_id, "sort":"1"]
        FYNetWork.request(GET_MERC_SHARE_URL + model.group_id, method: .get, params: params).responseJSON { (response: HTBaseModel<String>) in
            if let d = response.data {
                complete(d)
            }
        }
    }
    
    func requestAssociationActivity(complete: @escaping(Bool)->Void) {
        let params = ["keyword": keyword, "pageIndex":"\(pageIndex)", "pageSize":"20"]
        FYNetWork.request(ASSO_ACTIVITY, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTActivityModel]>) in
            if self.pageIndex == 1 {
                self.dataSource = [HTActivityModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }
    }
    
    func requestSignupMatch(complete: @escaping(Bool)->Void) {
        let params = ["matchActivityId":model.activityId]
        FYNetWork.request("singup/matchSignUp", params: params).responseJSON { (json) in
            complete(true)
        }
    }
    
    func requestCancelActivitySignUp(complete: @escaping(Bool)->Void) {
        let params = ["activity_id": model.activityId]
        FYNetWork.request("singup/cancelSignUpActivity1", params: params).responseJSON { (json) in
            complete(true)
        }
    }
    
    func requestCancelMatchSignUp(complete: @escaping(Bool)->Void) {
        let params = ["matchActivityId": model.activityId]
        FYNetWork.request("singup/cancelMatchSignUp", params: params).responseJSON { (json) in
            complete(true)
        }
    }
    
    func requestSetNote(complete: @escaping(Bool)->Void) {
        let params = ["activity_id": model.activityId]
        FYNetWork.request("activity/notifySetup", params: params).responseJSON { (json) in
            complete(true)
        }
    }
    
    func requestLiveACList(complete: @escaping(Bool)->Void) {
        let params = ["longitude":"\(HTUserInfo.share.longitude)", "latitude":"\(HTUserInfo.share.latitude)"]
        FYNetWork.request("activity/listBroadcastActivityList", params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTActivityModel]>) in
            if self.pageIndex == 1 {
                self.dataSource = [HTActivityModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }
    }
    /*
     public static final String STATUS_ARCHOR_NO_APPLY = "0"; //不能申请
     public static final String STATUS_ARCHOR_APPLY = "1"; //可以申请
     public static final String STATUS_ARROR_CAMERA = "2"; //单反直播
     public static final String STATUS_ARROR_ALL = "3"; //所有的都可以直播
     */
    
    func requestGetLiveStatus(complete: @escaping(String)->Void) {
        FYNetWork.request("broadcast/archorStatus", params: ["activityId":model.activityId]).responseJSON { (json) in
            let status = json["data"].stringValue
            complete(status)
        }
    }
    
    func requestApplyArchor(complete: @escaping(Bool)->Void) {
        FYNetWork.request("broadcast/archorApply", params: ["activityId":model.activityId]).responseJSON { (json) in
            complete(true)
        }
    }

}
