//
//  HTProductModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/3.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTProductModel: NSObject, HandyJSON {
    var id = ""
    var name = ""
    var price = ""
    var address = ""
    var discountPrice = ""
    var tag = ""
    var img = ""
    var startTime = ""
    var endTime = ""
    var peopleNumber = ""
    var remark = ""
    var type = ""
    var properties = ""
    var userId = ""
    var longitude = ""
    var latitude = ""
    
    var phoneNo = ""
    
    required override init(){}
}
