//
//  HTClubAcListModel.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/24.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTClubAcListModel: NSObject, HandyJSON {

     var weekDay = ""
       
    var activityBasics = [HTClubAcItemModel]()
    
    required override public init() {}
}

class HTClubAcItemModel: NSObject, HandyJSON {
    
    var activityId = ""
    
    var activityTime = ""
    
    var venueName = ""
    
    var activityName = ""
    
    var weekDay = ""

    required override public init() {}
}
