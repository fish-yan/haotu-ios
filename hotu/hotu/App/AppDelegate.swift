//
//  AppDelegate.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/19.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit
import IQKeyboardManager
import SwiftyJSON
import Flutter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var flutterEngine = FlutterEngine(name: "flutter_module")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initSDK()
        registerNoticication(application, launchOptions: launchOptions)
        return true
    }
    
    private func initSDK() {
        
        flutterEngine.run()
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        UMConfigure.initWithAppkey(UMENG_KEY, channel: "App Store")
        
        UMSocialManager.default()?.setPlaform(.QQ, appKey: QQ_ID, appSecret: QQ_KEY, redirectURL: "http://mobile.umeng.com/social")
        
        WXApi.registerApp(WX_KEY)
        
        TXUGCBase.setLicenceURL(VIDEO_LICENSE, key: VIDEO_KEY)
        RCIM.shared()?.initWithAppKey(RONG_CLOUD_KEY)
        
        FYNetWork.share.setParams = {
            if HTUserInfo.share.tokenId.isEmpty {
                return [:]
            } else {
                return ["user_token": HTUserInfo.share.tokenId]
            }
        }
        FYNetWork.share.config.codeKey = "code"
        FYNetWork.share.config.successCodeValue = "200"
        FYNetWork.share.config.msgKey = "msg"
        FYNetWork.share.special(["300"]) {
            if HTUserInfo.share.role != .visitor {
                HTUserInfo.share.clearUserInfo()
            }
        }
        #if DEBUG
        //        HTUserInfo.share.tokenId = "5c76f9af5cf940efbf7e66e2c9bfe661" // 余额
        //        HTUserInfo.share.tokenId = "8a659c5cb99046928bb0164f273f3b3e" // 保单
        //        HTUserInfo.share.tokenId = "8655f159be4a4f70a740de026693ce31"
        //        HTUserInfo.share.userId = "395"
        //        HTUserInfo.share.rcToken = "H617hzcSdokUKhknItjUSALgI0QoKoL/NTL+iT3lzIPHuh1XiBnOaWolv1pHV8hQ0tQ6TD6Wi+Hk95Gn9soiuA=="
        //        HTUserInfo.share.tokenId = "d85fd949504940ae85589965fdb09745"
        //        HTUserInfo.share.userId = "367"
        //        HTUserInfo.share.rcToken = "z5jYb8fnXalmGeeUqNNA71RxGxX4nXViK5MezBAPRGMqEEYCDazFyQyytuU0S7Q7dCouIwV3W+Uiqqk4cnuzgA=="
        #endif
        if HTUserInfo.share.role != .visitor {
            HTUtils.share.configAppInfo()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(badgeChanged), name: .HTBadgeChanged, object: nil)
    }
    
    @objc func badgeChanged() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = Int(HTRCUtils.share.getTotalUnreadCount())
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "hotu" {
            var type = ""
            var activityId = ""
            if let arr = url.host?.components(separatedBy: ",") {
                arr.forEach { (e) in
                    let earr = e.components(separatedBy: "=")
                    if earr.first == "type" {
                        type = earr.last ?? ""
                    }
                    if earr.first == "activityId" {
                        activityId = earr.last ?? ""
                    }
                }
            }
            print("type = \(type), activityId = \(activityId)")
            if type.isEmpty || activityId.isEmpty {return true}
            
            if type == "activity" {
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTActivityDetailViewController") as! HTActivityDetailViewController
                vc.vm.model.activityId = activityId
                visibleViewController?.navigationController?.pushViewController(vc, animated: true)
            } else if type == "match" {
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTMatchDetailViewController") as! HTMatchDetailViewController
                vc.vm.model.activityId = activityId
                visibleViewController?.navigationController?.pushViewController(vc, animated: true)
            } else if type == "live" {
                let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
                vc.vm.activityId = activityId
                visibleViewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return WXApi.handleOpen(url, delegate: HTWXUtil.share)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        RCIMClient.shared()?.setDeviceTokenData(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        remoteNotificationAction(userInfo)
    }
    
    private func registerNoticication(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let setting = UIUserNotificationSettings(types: [UIUserNotificationType.badge, UIUserNotificationType.sound, UIUserNotificationType.alert], categories: nil)
        application.registerUserNotificationSettings(setting)
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            remoteNotificationAction(userInfo)
        }
        
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            remoteNotificationAction(userInfo)
        }
    }
    
    private func remoteNotificationAction(_ userInfo: [AnyHashable: Any]) {
        if let vc = visibleViewController?.navigationController?.viewControllers.filter({$0 is HTConversationViewController}).first as? HTConversationViewController {
            visibleViewController?.navigationController?.popToViewController(vc, animated: true)
        } else {
            let json = JSON(userInfo)
            let targetId = json["rc"]["tId"].stringValue
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HTChatListViewController") as! HTChatListViewController
            visibleViewController?.navigationController?.pushViewController(vc, animated: false)
            switch targetId {
            case BADGE_FUNS:
                let cVC = sb.instantiateViewController(withIdentifier: "HTClubMemberViewController") as! HTClubMemberViewController
                cVC.type = .funs
                cVC.title = "粉丝"
                vc.navigationController?.pushViewController(cVC, animated: true)
                RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_SYSTEM, targetId: BADGE_FUNS)
                NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
            case BADGE_FAV:
                let cVC = sb.instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
                cVC.vm.type = "4"
                cVC.title = "赞"
                vc.navigationController?.pushViewController(cVC, animated: true)
                RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_SYSTEM, targetId: BADGE_FAV)
                NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
            case BADGE_AT:
                let cVC = sb.instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
                cVC.vm.type = "2"
                cVC.title = "@我"
                vc.navigationController?.pushViewController(cVC, animated: true)
                RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_SYSTEM, targetId: BADGE_AT)
                NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
            case BADGE_COMMENT:
                let cVC = sb.instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
                cVC.vm.type = "3"
                cVC.title = "评论"
                vc.navigationController?.pushViewController(cVC, animated: true)
                RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_SYSTEM, targetId: BADGE_COMMENT)
                NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
            default:
                let cVC = sb.instantiateViewController(withIdentifier: "HTConversationViewController") as! HTConversationViewController
                cVC.conversationType = RCConversationType.ConversationType_GROUP
                cVC.targetId = targetId
                vc.navigationController?.pushViewController(cVC, animated: true)
                NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
            }
            
        }
        
    }
}

