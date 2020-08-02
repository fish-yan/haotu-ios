//
//  FYShareViewController.swift
//  joint-operation
//
//  Created by Yan on 2019/1/14.
//  Copyright © 2019 Yan. All rights reserved.
//

import UIKit
import RongIMLib
import RongIMKit
import SwiftyJSON

enum HTShareType: Int {
    case activity = 0
    case match
    case live
    case image
}

class FYShareViewController: UIViewController {
    @IBOutlet weak var tencentView: UIStackView!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var timeLineBtn: UIButton!
    
    @IBOutlet weak var qqBtn: UIButton!
    
    @IBOutlet weak var qzoneBtn: UIButton!
        
    @IBOutlet weak var m1: UIButton!
    @IBOutlet weak var groupStackV: UIStackView!
    @IBOutlet weak var m2: UIButton!
    
    private var shareUrl = ""
    
    private var shareTitle = ""
    
    private var shareDes = ""
    
    private var shareImg: UIImage?
    
    var isShowGroup = false
    
    var activityId = ""
    
    var groupId = ""
    
    var type: HTShareType = .activity
            
    var height: CGFloat = 0
    
    var complete: ((Bool)->Void)?
    
    init(_ url: String, title: String, des: String, img: UIImage?) {
        super.init(nibName: "FYShareViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        shareUrl = url; shareTitle = title; shareDes = des; shareImg = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupStackV.isHidden = isShowGroup ? false : true
        height = isShowGroup ? 220 : 120
        bottom.constant = -height
        if UMSocialManager.default()?.isInstall(.QQ) == false {
            qqBtn.isHidden = true
            qzoneBtn.isHidden = true
            m1.isHidden = true
            m2.isHidden = true
        }
        if !WXApi.isWXAppInstalled() {
            wxBtn.isHidden = true
            timeLineBtn.isHidden = true
            m1.isHidden = true
            m2.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
    
    @IBAction func wxShareSessionAction(_ sender: UIButton) {
        if type == .image {
            wxShareImg(WXSceneSession)
        } else {
            wxShare(WXSceneSession)
        }
    }
    
    @IBAction func wxShareTimelineAction(_ sender: UIButton) {
        if type == .image {
            wxShareImg(WXSceneTimeline)
        } else {
            wxShare(WXSceneTimeline)
        }
    }
    
    @IBAction func qqShareActon(_ sender: UIButton) {
        if type == .image {
            qqShareImg(.QQ)
        } else {
            qqShare(.QQ)
        }
    }
    
    @IBAction func qzoneShareAction(_ sender: Any) {
        if type == .image {
            qqShareImg(.qzone)
        } else {
            qqShare(.qzone)
        }
    }
    
    @IBAction func groupShareAction(_ sender: UIButton) {
        groupShare()
    }
    
    func wxShareImg(_ type: WXScene) {
        if !WXApi.isWXAppInstalled() {
            Toast("该设备未安装微信")
            hidden()
            return
        }
        
        let imgObjc = WXImageObject()
        if let imgData = shareImg?.jpegData(compressionQuality: 1) {
            imgObjc.imageData = imgData
        }
        
        let msg = WXMediaMessage()
        msg.mediaObject = imgObjc
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = msg
        req.scene = Int32(type.rawValue)
        WXApi.send(req)
        hidden()
        if let c = complete {
            c(true)
        }
    }
    
    func wxShare(_ type: WXScene) {
        if !WXApi.isWXAppInstalled() {
            Toast("该设备未安装微信")
            hidden()
            return
        }
        let msg = WXMediaMessage()
        msg.title = shareTitle
        msg.description = shareDes
        msg.setThumbImage(shareImg ?? UIImage())
        
        let webPage = WXWebpageObject()
        webPage.webpageUrl = shareUrl
        msg.mediaObject = webPage
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = msg
        req.scene = Int32(type.rawValue)
        WXApi.send(req)
        hidden()
        if let c = complete {
            c(true)
        }
    }
    
    func qqShareImg(_ type: UMSocialPlatformType) {
        if !(UMSocialManager.default()?.isInstall(type) ?? false) {
            Toast("该设备未安装QQ")
            hidden()
            return
        }
        let msg = UMSocialMessageObject()
        let imgObj = UMShareImageObject()
        imgObj.shareImage = shareImg
        imgObj.thumbImage = shareImg
        msg.shareObject = imgObj
        UMSocialManager.default()?.share(to: type, messageObject: msg, currentViewController: self, completion: { (data, error) in
            self.hidden()
        })
        if let c = complete {
            c(true)
        }
    }
    
    func qqShare(_ type: UMSocialPlatformType) {
        if !(UMSocialManager.default()?.isInstall(type) ?? false) {
            Toast("该设备未安装QQ")
            hidden()
            return
        }
        let msg = UMSocialMessageObject()
        let webPage = UMShareWebpageObject()
        webPage.title = shareTitle
        webPage.webpageUrl = shareUrl
        webPage.descr = shareDes
        webPage.thumbImage = shareImg
        msg.shareObject = webPage
        
        UMSocialManager.default()?.share(to: type, messageObject: msg, currentViewController: self, completion: { (data, error) in
            self.hidden()
        })
        if let c = complete {
            c(true)
        }
    }
    
    func groupShare() {
        if activityId.isEmpty {
            Toast("活动id为空")
            return
        }
        if groupId.isEmpty {
            Toast("群id为空")
            return
        }
        let msg = RCTextMessage(content: "欢迎大家报名新活动！----点击报名")
        var typeValue = "RC:normalActivity"
        switch type {
        case .activity:
            typeValue = "RC:activity"
        case .match:
            typeValue = "RC:match"
        case .live:
            typeValue = "RC:live"
        default: break
        }
        let dict = ["type":typeValue,"activityId":activityId]
        msg?.extra = HTUtils.share.transformJSONStr(dict)
        msg?.senderUserInfo = RCIM.shared()?.currentUserInfo
        RCIM.shared()?.sendMessage(.ConversationType_GROUP, targetId: groupId, content: msg, pushContent: "分享了一个活动", pushData: "", success: { (msgId) in
            DispatchQueue.main.async {
                Toast("已成功分享到该群内")
                self.hidden()
                if let c = self.complete {
                    c(true)
                }
            }
            
        }, error: { (code, msgId) in
            DispatchQueue.main.async {
                if code == .NOT_IN_GROUP {
                    Toast("您当前不在该群 请先加入")
                }
                self.hidden()
            }
        })
    }
    
    
    func show() {
        bottom.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hidden() {
        bottom.constant = -height
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == view {
            hidden()
        }
    }
    
}
