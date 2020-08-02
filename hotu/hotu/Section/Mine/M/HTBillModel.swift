//
//  HTBillModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/7.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTBillSuperModel: NSObject, HandyJSON {
    
    var harvest = "0"
    
    var payed = "0"
    
    var acountDetailList = [HTBillModel]()
    
    required override init() {
        
    }
    
}

class HTBillModel: NSObject, HandyJSON {
    
    var type = "" // 1：收入，2：支出
    var amount = "" //
    var create_time = "" //
    var group_name = "" //
    var project_name = "" //
    var logo = "" //
    var source = "" // 4:会费，1：微信
    required override init() {
        
    }

}
