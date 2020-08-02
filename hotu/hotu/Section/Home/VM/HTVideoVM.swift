//
//  HTVideoVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoVM: NSObject {
    
    var dataSource = [HTVideoModel]()
    
    /// 排序方式（1 按时间 2 按评论数 3 按点赞数 4 按距离）
    var sortType = "4"
    /// 话题id
    var topic_id = ""
    /// 搜索条件[仅条件查询需要]
    var search = ""
    /// 媒体类型（1视频 2图片[仅类型查询需要]）
    var type = ""
            
    var page = 1
    
    var userId = ""
    
    var city = HTUserInfo.share.city
    
    var pubVideoModel: HTVideoModel?
        
    func request(complete: @escaping (Bool)->Void) {
        var params = ["sorttype":sortType,
                      "size":"10",
            "page":"\(page)",
            "city":city,
            "latitude":"\(HTUserInfo.share.latitude)",
            "longitude":"\(HTUserInfo.share.longitude)",
//            "search":search,
//            "type":type,
//            "topic_id":topic_id
        ]
        if !search.isEmpty {
            params["search"] = search
        }
        FYNetWork.request(VIDEO_LIST, method: .get, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTVideoModel]>) in
            if self.page == 1 {
                self.dataSource = [HTVideoModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            if let m = self.pubVideoModel {
                self.dataSource.insert(m, at: 0)
                self.pubVideoModel = nil
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestMyVideoList(complete: @escaping(Bool)->Void) {
        let params = ["userId": userId]
        FYNetWork.request(MY_VIDEO_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTVideoModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestMyFavVideoList(complete: @escaping(Bool)->Void) {
        let params = ["userId": userId]
        FYNetWork.request(MY_FAV_VIDEO_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTVideoModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestFav(videoId:String, isFav: Bool, complete: @escaping (Bool)->Void) {
        let api = isFav ? FAV_ACTION : UNFAV_ACTION
        let params = ["type":"1", "video_id":videoId]
        FYNetWork.request(api, method: .post, params: params, isLoading: false).responseJSON { (response: HTBaseModel<Any?>) in
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestGetShare(videoId: String, complete: @escaping (String)->Void) {
        let params = ["sort":"1", "video_id":videoId]
        FYNetWork.request(GET_SHARE_URL + "video", method: .get, params: params, isLoading: false).responseJSON { (json) in
            complete(json["data"].stringValue)
        }
    }
    
    func requestUpdateShareCount(videoId: String) {
        let params = ["videoId": videoId]
        FYNetWork.request(UPDATE_SHARE_COUNT, method: .get, params: params, isLoading: false)
    }
    
    func requestUpdatePlayCount(videoId: String) {
        let params = ["videoId": videoId]
        FYNetWork.request(UPDATE_PLAY_COUNT, method: .get, params: params, isLoading: false)
    }
}
