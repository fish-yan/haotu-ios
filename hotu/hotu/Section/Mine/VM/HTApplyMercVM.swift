//
//  HTApplyMercVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyMercVM: NSObject {
    
    var business_name = ""
    
    var business_address = ""
    
    var name = ""
    
    var telephone = ""
    
    var remark = ""
    
    var business_logo = ""
    
    func requestApplyMerc(complete: @escaping(Bool)->Void) {
        let params = ["business_name": business_name,
                      "business_address":business_address,
                      "name":name,
                      "telephone":telephone,
                      "remark":remark,
                      "business_logo":business_logo]
        FYNetWork.request(APPLY_MERC, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("申请成功")
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if business_name.isEmpty {
            Toast("请填写商户名称")
            return false
        }
        if business_address.isEmpty {
            Toast("请填写商户地址")
            return false
        }
        if name.isEmpty {
            Toast("请填写联系人姓名")
            return false
        }
        if telephone.isEmpty {
            Toast("请填写联系人电话")
            return false
        }
        if remark.isEmpty {
            Toast("请填写商户简介")
            return false
        }
        if business_logo.isEmpty {
            Toast("请上传店铺logo")
            return false
        }
        return true
    }

}
