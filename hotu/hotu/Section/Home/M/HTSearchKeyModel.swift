//
//  HTSearchKeyModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/13.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTSearchKeyModel: NSObject, HandyJSON {

    var id = ""
    
    var keyword = ""
    
    var searchNum = 0
    
    var type = ""
    
    var createTime = ""
        
    required override init(){}
}
