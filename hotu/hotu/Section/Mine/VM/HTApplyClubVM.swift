//
//  HTApplyVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyClubVM: NSObject {
    
    var group_name = ""
    
    var group_logo = ""
    
    var publish_name = ""
    
    var publish_telphone = ""
    
    var remark = ""
    
    func requestApplyClub(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["group_name": group_name,
                      "group_logo":group_logo,
                      "publish_name":publish_name,
                      "publish_telphone":publish_telphone,
                      "remark":remark]
        FYNetWork.request(APPLY_CLUB, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("申请成功")
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if group_name.isEmpty {
            Toast("请填写俱乐部名称")
            return false
        }
        if publish_name.isEmpty {
            Toast("请填写联系人姓名")
            return false
        }
        if publish_telphone.isEmpty {
            Toast("请填写联系人电话")
            return false
        }
        if remark.isEmpty {
            Toast("请填写俱乐部简介")
            return false
        }
        if group_logo.isEmpty {
            Toast("请上传俱乐部logo")
            return false
        }
        
        return true
    }

}
