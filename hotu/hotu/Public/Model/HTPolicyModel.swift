//
//  HTPolicyModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTPolicyModel: NSObject, HandyJSON {
    
    var type = ""
    var safeTitle = ""
    
    var startDate = ""
    
    var endDate = ""
    
    var safeEndTime = ""
    
    var safeAcount = ""
    
    var isRealName = ""
    
    var name = ""
    var groupName = ""
    var userId = ""
    var groupId = ""
    var date = ""
    var id = ""
    var activityId = ""
    var status = ""
    var safeCompanyLogo = ""
    var safeUrl = ""
    
    required override init() {}
}
