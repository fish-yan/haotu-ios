//
//  HTMsgVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/18.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMsgVM: NSObject {
    
    var dataSource = [HTCommentModel]()
    
    var type = "2"
        
    func requestMsg(complete: @escaping(Bool)->Void) {
        let params = ["type": type]
        FYNetWork.request(MSG_COMMENT_LIST, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTCommentModel]>) in
            if let d = response.data {
                self.dataSource = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestVideoDetail(_ videoId: String, complete: @escaping(HTVideoModel)->Void) {
        FYNetWork.request(VIDEO_DETAIL + videoId, method: .get, params: [:]).responseJSON { (response: HTBaseModel<HTVideoModel>) in
            if let d = response.data {
                complete(d)
            }
        }
    }

}
