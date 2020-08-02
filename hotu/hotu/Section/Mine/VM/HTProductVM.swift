//
//  HTMyProductVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTProductVM: NSObject {
    
    /// 0：全部 1：商品 2：课程
    var type = "1"
    
    var keyword = ""
    
    var userId = ""
    
    var productId = ""
    
    var dataSource = [HTProductModel]()
    
    var productModel = HTProductModel()
    
    func requestProducts(complete: @escaping(Bool)->Void) {
        var params = ["type": type]
        if !userId.isEmpty {
            params["targetUserId"] = userId
        }
        FYNetWork.request(MY_PRODUCT, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTProductModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (e) in
            complete(false)
        }
    }
    
    func requestProductList(complete: @escaping(Bool)->Void) {
        let params = ["keyword": keyword, "type": type]
        FYNetWork.request(PRODUCT_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTProductModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }
    }
    
    func requestProductDetail(complete: @escaping(Bool)->Void) {
        let params = ["id": productId]
        FYNetWork.request(PRODUCT_DETAIL, params: params).responseJSON { (response: HTBaseModel<HTProductModel>) in
            if let d = response.data {
                self.productModel = d
            }
            complete(true)
        }
    }
}
