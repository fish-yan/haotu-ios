//
//  HTLiveModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTLiveSuperModel: NSObject,HandyJSON {
    
    var operationCount = HTLiveCountModel()
    
    var activityName = ""
    
    var archorList = [HTMemberModel]()
    
    var imageList = [HTLiveModel]()
    //"0"; //不能申请 "1"; //可以申请 "2"; //单反直播 "3"; //所有的都可以直播
    var archorStatus = ""
    
    var ryChatroomId = ""
    
    required override init(){}
}

class HTLiveCountModel: NSObject,HandyJSON {
    
    var likeCount = "0"
    
    var seeCount = "0"
    
    var total = "0"
    
    required override init(){}
}


class HTLiveModel: NSObject, HandyJSON {

    var user_token = ""
    
    var activityId = ""
    
    var url = ""
    
    var thumbnail = ""
    
    var thumbnailBigger = ""
    
    var userId = ""
    
    var id = ""
    
    var likeCount = ""
    
    var seeCount = ""
    
    var createTime = ""
    
    var nickName = ""
    
    var userLogo = ""
    
    var candelete = ""
    
    var isLiked = ""
    
    var fileSize = ""
    
    var isAd = false
    
    var adImg = ""
    
    var adUrl = ""
    
    var adId = ""
    
    required override init(){}
}
