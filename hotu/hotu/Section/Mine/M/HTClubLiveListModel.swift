//
//  HTClubLiveListModel.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/24.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTClubLiveListModel: NSObject, HandyJSON {
    
    var activityId = ""
    
    var activityTime = ""
    
    var activityName = ""
    
    var archorImageDtos = [HTClubLiveItemModel]()
    
    var isSelected = true
    
    required override public init() {}
}

class HTClubLiveItemModel: NSObject, HandyJSON {
    
    var thumbnail = ""
    
    var likeCount = ""
    
    var isLiked = ""
    
    required override public init() {}
}
