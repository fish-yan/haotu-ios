//
//  HTMemberModel.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import HandyJSON

class HTMemberListModel: NSObject, HandyJSON {
    var managerList = [HTMemberModel]()
    
    var normalList = [HTMemberModel]()
    
    var groupBan = ""
    
    var groupTotalNum = ""
    
    required override init() {
    }
}

class HTMemberModel: NSObject, HandyJSON {
    
    var id = ""
    
    var user_id = ""
    
    var is_ban = ""
    
    var nick_name = ""
    
    var userLogo = ""
    
    var identify_status = ""
    
    var sex = ""
    
    var create_time = ""
    
    var group_id = ""
    // 1：我关注的，2：粉丝，3:相互关注 4:未关注
    var status = ""
    
    var idType = ""
    
    var idNo = ""
    
    var name = ""
    
    var isRealName = "0"
    
    var tel = ""
    
    var birthday = ""
    
    var followersNo = "0"
    
    var likedNo = "0"
    
    var fansNo = "0"
        
    var roleCode: HTRoleType = .visitor
    
    var autograph = ""
    
    var isSelected = false
    
    var replace_sign_up_number = "" // 挂靠人数

    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.status <-- ["status", "isFollowered", "is_follower"]
        mapper <<<
        self.nick_name <-- ["nick_name","nickName"]
        mapper <<<
        self.userLogo <-- ["head_icon", "userLogo", "user_logo", "url"]
        mapper <<<
        self.user_id <-- ["user_id","userId"]
        mapper <<<
        self.tel <-- ["tel", "phoneNO"]
        mapper <<<
        self.fansNo <-- ["fansNo", "fans"]
        mapper <<<
            self.roleCode <-- TransformOf<HTRoleType, String>(fromJSON: { (rawValue) -> HTRoleType in
                return HTRoleType(rawValue: rawValue ?? "0") ?? .visitor
            }, toJSON: { (type) -> String in
                return type?.rawValue ?? "0"
            })
    }
}
