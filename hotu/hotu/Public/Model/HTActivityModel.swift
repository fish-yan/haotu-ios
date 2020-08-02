//
//  HTActivityModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTActivityModel: NSObject, HandyJSON {
    
    var manager_id = ""
    
    var manager_name = ""
    
    var is_safe = ""
    
    var startTime = ""
    
    var endTime = ""
    
    var activityName = ""
    
    var activityId = ""
    
    var activity_phone_no = ""
    
    var activityAddress = ""
    
    var m_visitor_amount = "0"
    
    var groupLogo = ""
    
    var headIcon = ""
    
    var isPk = ""
    
    /// "1";//报名中  "2";//报名结束 "3";//活动结束 "5";//活动暂停 "6";//活动取消 "8"; //活动待退款
    var status = ""
    
    var managerUserId = ""
    
    var groupUserId = ""
    
    var groupPkId = ""
    
    var group_id = ""
    
    var groupName = ""
        
    var groupType = ""
    
    var activityType = ""
    
    var projectTypeName = ""
        
    var isOwer = ""
    
    var owner_name = ""
    
    var activityProperty = ""
    
    var battleNumber = ""
    
    var isSponser = ""
    
    var weekDay = ""
    
    var isSigned = ""
    
    var isBeginSaveScore = ""
    
    var isGovernment = ""
    
    var governmentActivityId = ""
    
    var governmentActivityStage = ""
    
    var governmentIsStart = ""
    
    var distance = ""
    /// 参加人数
    var sign_up_no = "0"
    
    var isSignUp = "0"
    
    var sign_up_list = [HTMemberModel]()
    ///总人数
    var total_no = ""
    
    var group_num = ""
    
    /// 活动价格
    var member_amount = ""
    /// 优惠价格
    var discount_amount = ""
    /// 活动介绍
    var remark = ""
    /// 海报地址
    var sports_poster = ""
    
    var latitude = ""
    
    var longitude = ""
    
    var stage = "1" // 1未开始，2直播中，3直播结束
    
    var isUpgradeMatch = "" // 1升级赛事 0不能升级赛事
    
    var totalPrice = ""
        
    var group_total_no = "" //总群数
    
    var isSelected = false
    
    var isAd = false
    
    var adImg = ""
    
    var adUrl = ""
        
    var adTitle = ""
    
    var venueName = ""

    
    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.activityId <-- ["activityId","activity_id"]
        mapper <<<
        self.activityName <-- ["activityName", "activity_name"]
        mapper <<<
        self.startTime <-- ["startTime", "start_date"]
        mapper <<<
        self.groupLogo <-- ["groupLogo", "group_logo"]
        mapper <<<
        self.groupName <-- ["groupName", "group_name"]
        mapper <<<
        self.activityAddress <-- ["activityAddress", "activity_address", "address"]
        mapper <<<
        self.activityType <-- ["activityType","projectType","sportType", "sport_type"]
        mapper <<<
        self.startTime <-- ["startTime", "start_date"]
        mapper <<<
        self.member_amount <-- ["member_amount", "m_visitor_amount"]
        mapper <<<
        self.discount_amount <-- ["w_discount_amount"]
        mapper <<<
        self.isSigned <-- ["isSigned", "is_sign_no"]
        mapper <<<
        self.sports_poster <-- ["sports_poster", "sportsPoster"]
        mapper <<<
        self.endTime <-- ["endTime", "end_time"]
    }
    
    class HTSignUpModel: NSObject, HandyJSON {
        var url = ""
        var user_id = ""
        var indentity = ""
        var nick_name = ""
        var sex = ""
        required override init() {}
    }

}
