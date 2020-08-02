//
//  HTMineVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/3.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMineVM: NSObject {
    
    var userId = ""
        
    var memberInfo = HTMemberModel()
    
    func requestUserCount(complete: @escaping(Bool)->Void) {
        FYNetWork.request(USER_INFO, params: ["targetUserId":userId], isLoading: false).responseJSON { (response: HTBaseModel<HTMemberModel>) in
            guard let member = response.data else {return}
            self.memberInfo = member
            complete(true)
        }
    }
    
    
}
