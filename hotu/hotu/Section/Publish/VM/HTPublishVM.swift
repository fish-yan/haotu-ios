//
//  HTPublishVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishVM: NSObject {
    
    /// 媒体类型（1视频 2图片）
    var type: HTPickerType = .image
    
    /// 描述
    var content = ""
    /// 视频地址
    var url = ""
    /// 腾讯视频id
    var tencentVideoId = ""
    /// 视频封面
    var coverUrl = ""
    
    /// 图片地址，以,分割
    var imageUrls = ""
    
    /// 详细地址
    var address = ""
    /// 话题id，以逗号分割
    var topicids = ""
    /// 商户id,与groupType匹配，
    var groupId = ""
    /// 商户类别（1真实商户 2模板商户 3、活动 4、教练 5、俱乐部）
    var groupType = ""
    /// @电话号码，多个以逗号隔开，格式为：备注:电话号码,备注:电话号码
    var atPhoneNos = ""
    /// @系统用户，多个以逗号隔开
    var atSystemUser = ""
    
    private var imgUrls = [String]()
    
    var imgs = [UIImage]()
    
    var topicArr = [HTTopicModel]()
    
    var phoneArr = [HTMemberModel]()
    
    var userArr = [HTMemberModel]()
                
    func requestPublishImgs(complete: @escaping(Bool)->Void) {
        guard checkImgsParams() else { return }
        requestUploadImgs { (success) in
            self.requestPublishAction { (success) in
                complete(true)
            }
        }
    }
    
    func requestPublishVideo(complete: @escaping(HTVideoModel?)->Void) {
        guard checkVideoParams() else { return }
        configParams()
        let params = ["url": url,
                      "imageUrls":imageUrls,
                      "content":content,
                      "province":HTUserInfo.share.province,
                      "city":HTUserInfo.share.city,
                      "area":HTUserInfo.share.area,
                      "address":address,
                      "longitude":"\(HTUserInfo.share.longitude)",
                      "latitude":"\(HTUserInfo.share.latitude)",
                      "topicids":topicids,
                      "groupId":groupId,
                      "groupType":groupType,
                      "tencentVideoId":tencentVideoId,
                      "type":type == .video ? "1" : "2",
                      "coverUrl":coverUrl,
                      "atPhoneNos":atPhoneNos,
                      "atSystemUser":atSystemUser]
        FYNetWork.request(PUBLISH_VIDEO2, params: params).responseJSON { (response: HTBaseModel<HTVideoModel>) in
            complete(response.data)
        }
    }
    
    private func requestPublishAction(complete: @escaping(Bool)->Void) {
        configParams()
        let params = ["url": url,
                      "imageUrls":imageUrls,
                      "content":content,
                      "province":HTUserInfo.share.province,
                      "city":HTUserInfo.share.city,
                      "area":HTUserInfo.share.area,
                      "address":address,
                      "longitude":"\(HTUserInfo.share.longitude)",
                      "latitude":"\(HTUserInfo.share.latitude)",
                      "topicids":topicids,
                      "groupId":groupId,
                      "groupType":groupType,
                      "tencentVideoId":tencentVideoId,
                      "type":type == .video ? "1" : "2",
                      "coverUrl":coverUrl,
                      "atPhoneNos":atPhoneNos,
                      "atSystemUser":atSystemUser]
        FYNetWork.request(PUBLISH_VIDEO2, params: params).responseJSON { (response: HTBaseModel<HTVideoModel>) in
            complete(true)
        }
    }
    
    private func requestUploadImgs(complete: @escaping(Bool)->Void) {
        self.imgUrls = [String]()
        showHUD()
        imgs.forEach {
            guard let img = $0.archive() else {
                return
            }
            HTAppVM.share.uploadImage(img, isZoom: true, isLogo: false) { (imgUrl) in
                if let url = imgUrl {
                    self.imgUrls.append(url)
                    if self.imgUrls.count == self.imgs.count {
                        hidHUD()
                        complete(true)
                    }
                } else {
                    hidHUD()
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    func requestSign(complete: @escaping(String)->Void) {
        FYNetWork.request(PUBLISH_VIDEO_SIGN,method: .get, params: [:]).responseJSON { (response: HTBaseModel<String>) in
            if let d = response.data {
                complete(d)
            }
        }
    }
    
    private func checkVideoParams() -> Bool {
        if url.isEmpty {
            Toast("请添加视频")
            return false
        }
        if content.isEmpty {
            Toast("请填写内容")
            return false
        }
        return true
    }
    
    private func checkImgsParams() -> Bool {
        if imgs.isEmpty {
            Toast("请添加图片")
            return false
        }
        if content.isEmpty {
            Toast("请填写内容")
            return false
        }
        return true
    }
    
    private func configParams() {
        imageUrls = imgUrls.joined(separator: ",")
        var tArr = [String]()
        topicArr.forEach { (m) in
            if content.contains("#\(m.content)# ") {
                tArr.append(m.id)
            }
        }
        topicids = tArr.joined(separator: ",")
        var pArr = [String]()
        phoneArr.forEach { (m) in
            if content.contains("@\(m.nick_name) ") {
                pArr.append(m.tel)
            }
        }
        atPhoneNos = pArr.joined(separator: ",")
        var fArr = [String]()
        userArr.forEach { (m) in
            if content.contains("@\(m.nick_name) ") {
                fArr.append(m.user_id)
            }
        }
        atSystemUser = fArr.joined(separator: ",")
    }
}
