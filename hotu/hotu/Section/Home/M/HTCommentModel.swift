//
//  HTCommentModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

enum HTCommentOpenType {
    case close, open, finish, finishClose
}

class HTCommentListModel: NSObject, HandyJSON {
    
    var commentList = [HTCommentModel]()
    
    var count = 0
    
    required override init(){}
}

class HTCommentModel: NSObject, HandyJSON {

    var id = ""
    
    var userId = ""
    
    var userLogo = ""
    
    var nickName = ""
    
    var content = ""
    
    var createTime = ""
    
    var likeCount = ""
    
    var isLike = ""
    
    var isDel = ""
    
    var videoId = ""
    
    var parentId = ""
    
    var commentNum: Int = 0
    
    var subCommentList = [HTCommentModel]()
    
    var subPage = 1
    
    var openType: HTCommentOpenType = .close
    
    var isFinish = false
    
    var faceUrl = ""
    
    var timeStr = ""
    
    var type = ""
    
    var operateContent = ""
    
    var targetUserId = ""
    
    var toUserName = ""
    
    var toUserId = ""
    
    required override init(){}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.userLogo <-- ["userImageUrl", "userLogo"]
        mapper <<<
        self.nickName <-- ["userNickName", "nickName"]
    }
}
