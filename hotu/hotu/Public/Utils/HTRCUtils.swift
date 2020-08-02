//
//  HTRCUtils.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/16.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTRCUtils: NSObject {

    static let share = HTRCUtils()
    
    func configRCInfo() {
        RCIM.shared()?.userInfoDataSource = self
        RCIM.shared()?.groupInfoDataSource = self
        RCIM.shared()?.groupMemberDataSource = self
        RCIM.shared()?.connectionStatusDelegate = self
        RCIM.shared()?.receiveMessageDelegate = self
        RCIM.shared()?.enableMessageAttachUserInfo = true
        RCIM.shared()?.enableMessageMentioned = true
        RCIM.shared()?.connect(withToken: HTUserInfo.share.rcToken, success: { (userId) in
            let userInfo = RCUserInfo(userId: userId, name: HTUserInfo.share.userName, portrait: HTUserInfo.share.headerImg)
            RCIM.shared()?.currentUserInfo = userInfo
            let count = self.getTotalUnreadCount()
            NotificationCenter.default.post(name: .HTBadgeChanged, object: [HTNotificationKey.badge:Int(count)], userInfo: nil)
        }, error: { (code) in
            print(code.rawValue)
        }, tokenIncorrect: {
            print("token失效或不存在")
        })
    }
    
    func getTotalUnreadCount() -> Int32 {
        let funs = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FUNS) ?? 0
        let fav = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FAV) ?? 0
        let at = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_AT) ?? 0
        let comment = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_COMMENT) ?? 0
        let noti1 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_APPLY_ARCHOR) ?? 0
        let noti2 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId:BADGE_ACTIVITY_DATE_NOTICE) ?? 0
        let msg = RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_GROUP.rawValue]) ?? 0
        let acnote = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_ACTIVITY_SIGN) ?? 0
        let count = funs + fav + at + comment + noti1 + noti2 + msg + acnote
        return count
    }
}

extension HTRCUtils: RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupMemberDataSource, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate {
    
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        let rcUserInfo = RCUserInfo(userId: HTUserInfo.share.userId, name: HTUserInfo.share.userName, portrait: HTUserInfo.share.headerImg)
        completion(rcUserInfo)
    }
    
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        print(Thread.current)
        DispatchQueue.main.async {
            self.requestClubDetail(groupId) { (model) in
                print(Thread.current)
                let groupInfo = RCGroup(groupId: groupId, groupName: model.group_name, portraitUri: model.group_logo)
                completion(groupInfo)
            }
        }
    }
    
    func getAllMembers(ofGroup groupId: String!, result resultBlock: (([String]?) -> Void)!) {
        DispatchQueue.main.async {
            self.requestClubMemberList(groupId) { (list) in
                let ids = list.map({$0.user_id})
                resultBlock(ids)
            }
        }
    }
    
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        if status == .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
            DispatchQueue.main.async {
                RCIM.shared()?.disconnect()
                RCIM.shared()?.logout()
                let alert = UIAlertController(title: "提示", message: "您的账号已在其他设备登录", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default) { (alert) in
                    HTUserInfo.share.clearUserInfo()
                }
                alert.addAction(action)
                visibleViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .HTBadgeChanged, object: [HTNotificationKey.badge:Int(left)], userInfo: nil)
            NotificationCenter.default.post(name: .HTReceivedMsg, object: message, userInfo: nil)
        }
    }
    
}

extension HTRCUtils {
    func requestClubDetail(_ groupId: String, complete: @escaping(HTClubModel)->Void) {
        let params = ["group_id": groupId]
        FYNetWork.request(CLUB_DETAIL, params: params).responseJSON { (response: HTBaseModel<HTClubModel>) in
            if let d = response.data {
                complete(d)
            }
        }
    }
    
    func requestClubMemberList(_ groupId: String, complete: @escaping([HTMemberModel])->Void) {
        let params = ["group_id":groupId]
        FYNetWork.request(CLUB_MEMBER_LIST, params: params).responseJSON { (response: HTBaseModel<HTMemberListModel>) in
            if let m = response.data {
                let memberList = m.managerList + m.normalList
                complete(memberList)
            }
        }
    }
}
