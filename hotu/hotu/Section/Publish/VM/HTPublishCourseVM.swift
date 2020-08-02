//
//  HTPublishCourseVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/3.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishCourseVM: NSObject {
    
    var model = HTProductModel()
    
    func requestPublishProduct(complete: @escaping(Bool)->Void) {
        if model.type == "1" {
            guard checkPorductParams() else {return}
        } else {
            guard checkCourseParams() else {return}
        }
        let params = ["name":model.name,
                      "price":model.price,
                      "tag":model.tag,
                      "img":model.img,
                      "startTime":model.startTime,
                      "endTime":model.endTime,
                      "peopleNumber":model.peopleNumber,
                      "remark":model.remark,
                      "address":model.address,
                      "type":model.type,
                      "properties":model.properties]
        FYNetWork.request(PUBLISH_COURSE, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    private func checkCourseParams() -> Bool {
        if model.name.isEmpty {
            Toast("请输入课程主题")
            return false
        }
        if model.peopleNumber.isEmpty {
            Toast("请输入上课人数")
            return false
        }
        if model.price.isEmpty {
            Toast("请输入课程费用")
            return false
        }
        if model.address.isEmpty {
            Toast("请输入上课地址")
            return false
        }
        if model.startTime.isEmpty {
            Toast("请选择上课时间")
            return false
        }
        if model.endTime.isEmpty {
            Toast("请选择课程有效期")
            return false
        }
        if model.remark.isEmpty {
            Toast("请填写课程介绍")
            return false
        }
        return true
    }
    
    private func checkPorductParams() -> Bool {
        if model.name.isEmpty {
            Toast("请输入商品标题")
            return false
        }
        if model.price.isEmpty {
            Toast("请输入商品价格")
            return false
        }
        if model.discountPrice.isEmpty {
            Toast("请输入商品折后价格")
            return false
        }
        if model.tag.isEmpty {
            Toast("请选择课程有效期")
            return false
        }
        if model.img.isEmpty {
            Toast("请上传产品图片")
            return false
        }
        return true
    }
    
}
