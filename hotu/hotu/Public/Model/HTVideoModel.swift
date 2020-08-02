//
//  HTVideoModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTVideoModel: NSObject, HandyJSON {
    var id = ""
    var url = ""
    var content = ""
    var address = ""
    var createTime = ""
    var commentCount = ""
    var likeCount = ""
    var storeCount = ""
    var isLike = ""
    var isStore = ""
    var userImageUrl = ""
    var userId = ""
    var userNickName = ""
    var imageUrls = [HTVideoImageModel]()
    var type = ""
    var geoHash = ""
    var coverUrl = ""
    var txId = ""
    var forwardCount = ""
    var seeCount = ""
    var activityId = ""
    var activityName = ""
    
    // 连接
    var linkedImage = ""
    var linkedTitle = ""
    var linkedType = ""
    var linkedUserId = ""
    var linkedId = ""
    
    // 直播
    var isLiveBroadCast = "0"
    var liveBroadCastActivityId = ""
    var isAd = false
    var adImg = ""
    var adUrl = ""
    var statusStr = ""
    var status = ""
    var groupName = ""
    var groupLogo = ""
    var groupId = ""
    var remark = ""
    
    required override init() {}
    
    class HTVideoImageModel: NSObject, HandyJSON {
        var id = ""
        var videoId = ""
        var url = ""
        required override init() {}
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.coverUrl <-- ["coverUrl", "cover_url", "sportsPoster"]
        mapper <<<
        self.likeCount <-- ["likeCount", "like_count"]
        mapper <<<
        self.createTime <-- ["createTime", "startTime"]
    }
}
