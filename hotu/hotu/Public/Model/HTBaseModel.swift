//
//  HTBaseModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

open class HTBaseModel<T>: NSObject, HandyJSON {
    
    var msg = ""
    var code = ""
    
    var data: T?
    
    required override public init() {}
}
