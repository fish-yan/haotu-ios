
//
//  HTBankModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTItemModel: NSObject, HandyJSON {
    var id = ""
    var itemCode = ""
    var itemName = ""
    var parentCode = ""
    var sortNo = ""
    var isLeaf = ""
    var isRoot = ""
    var createTime = ""
    var modifyTime = ""
    var ext = ""
    var count: Double = 0
    var title = ""
    var remark = ""
    
    required override init(){}
}
