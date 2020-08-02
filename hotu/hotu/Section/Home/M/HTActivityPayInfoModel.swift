//
//  HTActivityPayInfoModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/11.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTActivityPayInfoModel: NSObject, HandyJSON {
    
    var womanPrice = "0"
    
    var manPice = "0"
    
    var safeList = [HTItemModel]()
    
    var payList = [HTItemModel]()
    
    required override init() {}

}

class HTActivityPayResultModel: NSObject, HandyJSON {
    
    var womanPmerchantOrderNorice = ""
    
    var orderCreateTime = ""
    
    var returnCode = ""
    
    var sftOrderNo = ""
    
    var payInfo = HTWXPayModel()
    
    required override init() {}

}
