//
//  HTApplyCoachVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyCoachVM: NSObject {
    
    var name = ""
    
    var nick_name = ""
    
    var telephone = ""
    
    var remark = ""
    
    var qualification_certificate = ""
    
    var identity_certificate = ""
    
    var coachLogo = ""

    func requestApplyCoach(complete: @escaping(Bool)->Void) {
        guard checkParams() else {return}
        let params = ["name": name,
                      "nick_name":nick_name,
                      "telephone":telephone,
                      "remark":remark,
                      "qualification_certificate":qualification_certificate,
                      "identity_certificate":identity_certificate]
        FYNetWork.request(APPLY_COACH, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("申请成功")
            complete(true)
        }
    }
    
    private func checkParams() -> Bool {
        if name.isEmpty {
            Toast("请填写您的姓名")
            return false
        }
        if nick_name.isEmpty {
            Toast("请填写您的昵称")
            return false
        }
        if telephone.isEmpty {
            Toast("请填写联系号码")
            return false
        }
        if remark.isEmpty {
            Toast("请填写介绍")
            return false
        }
        if identity_certificate.isEmpty {
            Toast("请上传一寸白底照")
            return false
        }
        if qualification_certificate.isEmpty {
            Toast("请上传资质证书")
            return false
        }
        return true
    }
}
