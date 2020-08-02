//
//  HTMyClubVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTClubVM: NSObject {
    
    var dataSource = [HTClubModel]()
    
    var model = HTClubModel()
    
    var listModel = HTMemberListModel()
    
    var memberList = [HTMemberModel]()
    
    var keyword = ""
    
    var pageIndex = 1
    
    var clubAcList = [HTClubAcListModel]()
    
    var clubLiveList = [HTClubLiveListModel]()
    
    func requestMyClub(complete: @escaping(Bool)->Void) {
        let params = ["status": "1"]
        FYNetWork.request(MY_CLUB, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTClubModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }
    }
    
    func requestClubDetail(_ isLoading: Bool = true ,complete: @escaping(Bool)->Void) {
        let params = ["group_id": model.group_id]
        FYNetWork.request(CLUB_DETAIL, params: params, isLoading: isLoading).responseJSON { (response: HTBaseModel<HTClubModel>) in
            if let d = response.data {
                self.model = d
                complete(true)
            }
            complete(false)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestClubMemberList(complete: @escaping(Bool)->Void) {
        let params = ["group_id": model.group_id]
        FYNetWork.request(CLUB_MEMBER_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<HTMemberListModel>) in
            if let m = response.data {
                self.listModel = m
                self.memberList = m.managerList + m.normalList
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestAssoMCC(type: String, complete: @escaping(Bool)->Void) {
        let params = ["type": type, "keyword":keyword, "pageIndex":"\(pageIndex)", "pageSize": "20"]
        FYNetWork.request(ASSO_MCC, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTClubModel]>) in
            if self.pageIndex == 1 {
                self.dataSource = [HTClubModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            complete(true)
        }
    }

    func requestExitClub(complete: @escaping(Bool)->Void) {
        let params = ["group_id": model.group_id]
        FYNetWork.request(EXIT_CLUB, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    func requestJoinClub(complete: @escaping(Bool)->Void) {
        let params = ["group_id": model.group_id]
        FYNetWork.request(JOIN_CLUB, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestUpdateClubInfo(complete: @escaping(Bool)->Void) {
        let params = ["group_id": model.group_id, "group_name": model.group_name, "notice": model.notice]
        FYNetWork.request(UPDATE_CLUB_INFO, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    func requestClubInfo(complete: @escaping(Bool)->Void) {
        FYNetWork.request("group/viewGroupInfo", params: ["group_id":model.group_id]).responseJSON { (response:  HTBaseModel<HTClubModel>) in
            if let m = response.data {
                self.model = m
            }
            complete(true)
        }
    }
    
    
    func requestClubActivity(complete: @escaping(Bool)->Void) {
        FYNetWork.request("activity/listAfterOneWeekActivity", params: ["group_id":model.group_id], isLoading: false).responseJSON { (response:  HTBaseModel<[HTClubAcListModel]>) in
            if let list = response.data {
                self.clubAcList = list
            }
            complete(true)
        }
    }
    
    func requestClubLive(complete: @escaping(Bool)->Void) {
        let params = ["groupId":model.group_id, "page":"\(pageIndex)", "pageSize":"10"]
        FYNetWork.request("broadcast/listGroupLiveBroadcast", params: params, isLoading:  false).responseJSON { (response:  HTBaseModel<[HTClubLiveListModel]>) in
            if self.pageIndex == 1 {
                self.clubLiveList = [HTClubLiveListModel]()
            }
            if let list = response.data {
                self.clubLiveList += list
            }
            complete(true)
        }
    }
}
