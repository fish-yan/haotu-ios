//
//  HTWXPayModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/11.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTWXPayModel: NSObject, HandyJSON {
    
    var packageMsg = ""
    
    var sign = ""
    
    var partnerid = ""
    
    var prepayid = ""
    
    var nonceStr = ""
    
    var timeStamp: UInt32 = 0
    
    required override init() {}
}
