//
//  HTCityModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/14.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTCityListMdoel: NSObject, HandyJSON {
    
    var initial = ""
    
    var citys = [HTCityModel]()
    
    required override init() {}
    
}

class HTCityModel: NSObject, HandyJSON {
    
    var city_key = ""
    
    var city_name = ""
    
    var initials = ""
    
    var pinyin = ""
    
    var short_name = ""
    
    required override init() {}
}
