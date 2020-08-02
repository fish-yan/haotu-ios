//
//  HTClubModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/2.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTClubModel: NSObject, HandyJSON {
    
    var group_id = ""
    
    var group_logo = ""
    
    var group_name = ""
    /// 1: 俱乐部 3：教练 5：商家
    var group_type = ""
    
    var province = ""
    
    var city = ""
    
    var area = ""
    
    var address = ""
        
    var notice = ""
    
    var isExamine = ""
    
    var username = ""
    
    var battleNumber = ""
    
    var remarkImage = ""
    
    var qrCode = ""
    
    var userId = ""
    
    var phoneNo = ""
    
    var project_type = ""
    
    var project_name = ""
    
    var remark = ""
    
    var ownerName = ""
    
    var group_member_images = [HTMemberModel]()
    
    required override init() {
        
    }
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.remark <-- ["remark", "group_mark"]
        mapper <<<
        self.address <-- ["address", "activity_venue_address"]
        mapper <<<
        self.group_type <-- ["group_type", "groupType", "type"]
        mapper <<<
        self.group_id <-- ["group_id", "groupId", "id"]
        mapper <<<
        self.group_name <-- ["group_name", "groupName"]
        mapper <<<
        self.group_logo <-- ["group_logo", "groupLogo"]
        mapper <<<
        self.ownerName <-- ["ownerName", "owner_name"]
    }
}
