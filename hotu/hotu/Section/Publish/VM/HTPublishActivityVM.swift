//
//  HTPublishActivityVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishActivityVM: NSObject {
    
    var model = HTActivityModel()
    
    func requestPublishActivity(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["activity_name": model.activityName,
                      "start_date":model.startTime,
                      "activity_address":model.activityAddress,
                      "total_no":model.total_no,
                      "m_visitor_amount":model.member_amount,
                      "w_discount_amount":model.discount_amount,
                      "activity_property": model.activityProperty,
                      "activity_type": model.activityType,
                      "endTime":model.endTime,
                      "remark":model.remark]
        FYNetWork.request(PUBLISH_ACTIVITY, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("发布成功")
            complete(true)
        }
    }
    
    func requestUpdateActivity(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["activity_id":model.activityId,
                      "activity_name": model.activityName,
                      "start_date":model.startTime,
                      "activity_address":model.activityAddress,
                      "total_no":model.total_no,
                      "m_visitor_amount":model.member_amount,
                      "w_discount_amount":model.discount_amount,
                      "activityProperty": model.activityProperty,
                      "activity_type": model.activityType,
                      "endTime":model.endTime,
                      "remark":model.remark]
        FYNetWork.request("activity/updateActivity", params: params).responseJSON { (response: HTBaseModel<String>) in
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
            Toast("请输入活动开始时间")
            return false
        }
        if model.endTime.isEmpty {
            Toast("请输入活动结束时间")
            return false
        }
        if model.activityAddress.isEmpty {
            Toast("请输入活动地点")
            return false
        }
        if model.total_no.isEmpty {
            Toast("请输入可参加人数")
            return false
        }
        if model.member_amount.isEmpty {
            Toast("请输入活动费用")
            return false
        }
        if model.activityType.isEmpty {
            Toast("请选择活动类型")
            return false
        }
        if model.activityProperty.isEmpty {
            Toast("请选择固定活动/临时活动")
            return false
        }
        
        return true
    }

}
