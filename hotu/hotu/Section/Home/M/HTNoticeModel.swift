//
//  HTNoticeModel.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/5.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTNoticeModel: NSObject, HandyJSON {
    
    var id = ""
    
    var userId = ""
    
    var content = ""
    
    // 0 普通消息，1申请
    var type = ""
    
    // 0待审核，1审核通过，2审核拒绝
    var status = ""
    
    var createTime = ""
    
    required override init() {}
}
