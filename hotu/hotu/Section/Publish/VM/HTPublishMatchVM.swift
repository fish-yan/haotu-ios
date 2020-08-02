//
//  HTPublishMatchVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/3.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishMatchVM: NSObject {
    
    var model = HTActivityModel()
    
    var anchorList = [HTMemberModel]()
    
    func requestPublishMatch(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let userids = anchorList.map({$0.user_id}).joined(separator: ",")
        let params = ["activity_name": model.activityName,
                      "start_date":model.startTime,
                      "activity_address":model.activityAddress,
                      "activity_type": model.activityType,
                      "sports_poster":model.sports_poster,
                      "archor_user_id":userids,
                      "m_visitor_amount":model.m_visitor_amount,
                      "group_num":model.group_num]
        FYNetWork.request(PUBLISH_MATCH, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("发布成功")
            complete(true)
        }
    }
    
    func requestUpdateMatch(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let userids = anchorList.map({$0.user_id}).joined(separator: ",")
        let params = ["activityName": model.activityName,
                      "startDate":model.startTime,
                      "activityAddress":model.activityAddress,
                      "activityType": model.activityType,
                      "sports_poster":model.sports_poster,
                      "signUpAmount":model.m_visitor_amount,
                      "activityId":model.activityId,
                      "totalNum":model.total_no,
                      "archors":userids]
        FYNetWork.request(UPDATE_MATCH, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("发布成功")
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if model.activityName.isEmpty {
            Toast("请输入活动主题")
            return false
        }
        if model.startTime.isEmpty {
            Toast("请输入活动时间")
            return false
        }
        if model.activityAddress.isEmpty {
            Toast("请输入活动地点")
            return false
        }
        if model.m_visitor_amount.isEmpty {
            Toast("请输入报名费用")
            return false
        }
        if model.activityType.isEmpty {
            Toast("请选择活动类型")
            return false
        }
        
        return true
    }
    
    
}
