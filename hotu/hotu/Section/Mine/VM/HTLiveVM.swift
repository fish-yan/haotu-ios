//
//  HTApplyAnchorVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLiveVM: NSObject {
    
    var userId = ""
    
    var archor_name = ""
    
    var telephone = ""
        
    var indentity_no = ""
    
    var indentity_front = ""
    
    var indentity_background = ""
    
    var dataSource = [HTVideoModel]()
    
    var page = 1
    
    var activityId = ""
        
    var liveDataSource = HTLiveSuperModel()
    
    var anchors = [HTMemberModel]()
    
    var addAnchors = [HTMemberModel]()
    
    var keyword = ""
    
    var sort = "1"
    
    var imgs = [String]()
        
    func requestApplyAnchor(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["archor_name": archor_name,
        "telephone": telephone,
        "indentity_no":indentity_no,
        "indentity_front": indentity_front,
        "indentity_background": indentity_background]
        FYNetWork.request(APPLY_ANCHOR, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if archor_name.isEmpty {
            Toast("请填写姓名")
            return false
        }
        if !telephone.isPhone() {
            Toast("请正确填写联系号码")
            return false
        }
        if !indentity_no.isIDCard() {
            Toast("请填写身份证号")
            return false
        }
        if indentity_front.isEmpty {
            Toast("请上传身份证正面")
            return false
        }
        if indentity_background.isEmpty {
            Toast("请上传身份证反面")
            return false
        }
        
        return true
    }
    

    func requestLiveList(complete: @escaping(Bool)->Void) {
        let params = ["targetUserId": userId]
        FYNetWork.request(MY_LIVE_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTVideoModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestLiveDetail(complete: @escaping(Bool)->Void) {
        let params = ["pageIndex": "\(page)", "pageSize":"9", "activityId":activityId, "sort":sort]
        FYNetWork.request(MY_LIVE_DETAIL, params: params, isLoading: false).responseJSON { (response: HTBaseModel<HTLiveSuperModel>) in
            if self.page == 1 {
                self.liveDataSource = HTLiveSuperModel()
            }
            if let d = response.data {
                if self.page == 1 {
                    self.liveDataSource = d
                } else {
                    self.liveDataSource.imageList += d.imageList
                }
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestLiveAddCount(_ id: String) {
        let params = ["id": id]
        FYNetWork.request(UPDATE_LIVE_SEE_COUNT, params: params, isLoading: false)
    }
    
    func requestShare(complete: @escaping(String)->Void) {
        let params = ["activityId": activityId]
        FYNetWork.request(GET_LIVE_SHARE_URL, method: .get, params: params).responseJSON { (response: HTBaseModel<String>) in
            if let d = response.data {
                complete(d)
            }
        }
    }
    
    func requestShareQR(complete: @escaping(String)->Void) {
        let params = ["activityId": activityId]
        FYNetWork.request(GET_SHARE_QRCODE, method: .get, params: params).responseJSON { (response: HTBaseModel<String>) in
            if let d = response.data {
                complete(d)
            }
        }
    }
    
    func requestAnchors(complete: @escaping(Bool)->Void) {
        let params = ["id": activityId]
        FYNetWork.request(LIVE_ANCHOR, params: params).responseJSON { (response: HTBaseModel<[HTMemberModel]>) in
            if let d = response.data {
                self.anchors = d
            }
            complete(true)
        }
    }
    
    func requestAddAnchor(complete: @escaping(Bool)->Void) {
        let ids = addAnchors
            .map({$0.user_id})
            .filter { (id) -> Bool in
                return !anchors.map({$0.user_id}).contains(id)
        }
        .joined(separator: ",")
        if ids.isEmpty {return}
        let params = ["activityId": activityId, "userId":ids]
        FYNetWork.request(ADD_ANCHOR, params: params).responseJSON { (response: HTBaseModel<String>) in
            self.requestAnchors(complete: complete)
        }
    }
    
    func requestAnchorList(complete: @escaping(Bool)->Void) {
        let params = ["activityId": activityId, "keyword":keyword, "pageIndex": "\(page)", "pageSize":"20"]
        FYNetWork.request(ANCHOR_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTMemberModel]>) in
            if self.page == 1 {
                self.anchors = [HTMemberModel]()
            }
            if let d = response.data {
                self.anchors += d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestAddPic(complete: @escaping(Bool)->Void) {
        let imgStr = imgs.joined(separator: ",")
        let params = ["activityId": activityId, "images": imgStr]
        FYNetWork.request("broadcast/add", params: params).responseJSON{ (json) in
            complete(true)
        }
    }
    
    func requestLiveListAll(complete: @escaping(Bool)->Void) {
        let params = ["pageIndex": "\(page)", "pageSize":"10"]
        FYNetWork.request("broadcast/listAll", params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTVideoModel]>) in
            if self.page == 1 {
                self.dataSource = [HTVideoModel]()
            }
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestVerify(complete: @escaping(Bool)->Void) {
        if archor_name.count < 2 {
            Toast("请输入真实姓名")
            return
        }
        if indentity_no.isEmpty {
            Toast("请输入正确的身份证号码")
            return
        }
        if telephone.isEmpty {
            Toast("请输入手机号码")
            return
        }
        if indentity_front.isEmpty {
            Toast("请上传身份证正面")
            return
        }
        if indentity_background.isEmpty {
            Toast("请上传身份证反面")
            return
        }
        let params = ["idNo": indentity_no, "name":archor_name, "phoneNo":telephone, "idFront":indentity_front, "idBehind":indentity_background]
        FYNetWork.request(USER_VERIFITY, params: params).responseJSON { (json) in
            Toast("认证成功") {
                complete(true)
                NotificationCenter.default.post(name: .HTUserInfoChanged, object: nil)
            }
        }
    }
}
