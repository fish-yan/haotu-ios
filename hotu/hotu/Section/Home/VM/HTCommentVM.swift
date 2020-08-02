//
//  HTCommentVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCommentVM: NSObject {
    
    var videoModel = HTVideoModel()
    
    var dataSource = [HTCommentModel]()
    
    var content = ""
        
    var commentId = "0"
    
    var currentIndex = 0
    
    var total = 0
    
    var page = 1
    
    var nomore = false
    
    var atMemberList = [HTMemberModel]()
        
    func request(complete: @escaping (Bool)->Void) {
        let params = ["sorttype":"1",
                      "size":"20",
                      "page":"\(page)",
                      "userId":HTUserInfo.share.userId,
                      "video_id":videoModel.id,
                      "parentId":"0"]
        FYNetWork.request(COMMENT_LIST, method: .get, params: params, isLoading: false).responseJSON { (response: HTBaseModel<HTCommentListModel>) in
            if self.page == 1 {
                self.dataSource = [HTCommentModel]()
            }
            if let d = response.data {
                self.nomore = d.commentList.count < 20
                self.dataSource += d.commentList
                self.total = d.count
            }
            complete(true)
        }
    }
    
    func requestSubCommentList(index: Int, complete: @escaping (Bool)->Void) {
        let params = ["sorttype":"1",
                      "size":"20",
                      "page":"\(self.dataSource[index].subPage)",
                      "userId":HTUserInfo.share.userId,
                      "video_id":videoModel.id,
                      "parentId":self.dataSource[index].id]
        FYNetWork.request(COMMENT_LIST, method: .get, params: params, isLoading: false).responseJSON { (response: HTBaseModel<HTCommentListModel>) in
            let model = self.dataSource[index]
            if model.subPage == 1 {
                model.subCommentList = [HTCommentModel]()
            }
            if let d = response.data {
                model.subCommentList += d.commentList
            }
            complete(true)
        }
    }
    
    func requestAddComment(complete: @escaping(HTCommentModel)->Void) {
        let userIds = atMemberList
            .filter({content.contains("@\($0.nick_name) ")})
            .map({$0.user_id})
            .joined(separator: ",")
        let params = ["video_id": videoModel.id,"content":content, "parentId":commentId, "atSystemUser":userIds]
        FYNetWork.request(ADD_COMMENT, params: params).responseJSON { (response: HTBaseModel<HTCommentModel>) in
            if let d = response.data {
                d.nickName = HTUserInfo.share.userName
                d.isDel = "1"
                d.userLogo = HTUserInfo.share.headerImg
                complete(d)
            }
        }
    }
    
    func requestDeleteComment(complete: @escaping(Bool)->Void) {
        let params = ["video_id": videoModel.id, "id":commentId]
        FYNetWork.request(DELETE_COMMENT, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }

}
