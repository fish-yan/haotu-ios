//
//  HTHomeViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTHomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var visView: UIVisualEffectView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    @IBOutlet weak var badge: UIView!
    @IBOutlet weak var segment: FYSegment!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let tabVC = self.tabBarController as? HTTabBarViewController {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            tabVC.htTabBar.theme = index == 0 ? .dark : .light
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if let tabVC = self.tabBarController as? HTTabBarViewController {
            tabVC.htTabBar.theme = .light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavView()
        badgeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(badgeChanged), name: .HTBadgeChanged, object: nil)
    }
    
    @objc func badgeChanged() {
        DispatchQueue.main.async {
            let funs = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FUNS) ?? 0
            let fav = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FAV) ?? 0
            let at = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_AT) ?? 0
            let comment = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_COMMENT) ?? 0
            let noti1 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_APPLY_ARCHOR) ?? 0
            let noti2 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId:BADGE_ACTIVITY_DATE_NOTICE) ?? 0
            let msg = RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_GROUP.rawValue]) ?? 0
            let count = funs + fav + at + comment + noti1 + noti2 + msg
            self.badge.isHidden = count <= 0 || HTUserInfo.share.role == .visitor
            let acnote = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_ACTIVITY_SIGN) ?? 0
            self.segment.showTag(on: 2, isHidden: acnote <= 0)
        }
    }
    
    private func configNavView() {
        func configNavTheme(isDark: Bool) {
            if isDark {
                navView.backgroundColor = .clear
                visView.alpha = 0.3
                searchBtn.setTitleColor(.white, for: .normal)
                msgBtn.setTitleColor(.white, for: .normal)
                segment.defautColor = .white
                segment.selectedColor = .white
                searchBtn.setImage(UIImage(named: "icon_search_white"), for: .normal)
                msgBtn.setImage(UIImage(named: "icon_msg_white"), for: .normal)
            } else {
                navView.backgroundColor = .white
                visView.alpha = 0
                searchBtn.setTitleColor(.black, for: .normal)
                msgBtn.setTitleColor(.black, for: .normal)
                segment.defautColor = .black
                segment.selectedColor = .black
                searchBtn.setImage(UIImage(named: "icon_search_black"), for: .normal)
                msgBtn.setImage(UIImage(named: "icon_msg_black"), for: .normal)
            }
        }
        navHeight.constant = UIApplication.shared.statusBarFrame.height + 44
        segment.titleArray = ["视频", "直播","群活动"]
        segment.selectAction = { index in
            UIView.animate(withDuration: 0.25) {
                configNavTheme(isDark: index == 0)
            }
            if let tabVC = self.tabBarController as? HTTabBarViewController {
                tabVC.htTabBar.theme = index == 0 ? .dark : .light
            }
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            if let vc = self.children.filter({$0 is HTVideoViewController}).first as? HTVideoViewController {
                if index == 0 {
                    CATransaction.setCompletionBlock {
                        vc.play()
                    }
                } else {
                    vc.resetPlayer()
                }
            }
            if let vc = self.children.filter({$0 is HTActivityViewController}).first as? HTActivityViewController {
                if index == 2 {
                    vc.firstRequest()
                    if !self.segment.isTagHidden(on: 2) {
                        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_ACTIVITY_SIGN)
                        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
                        FYNetWork.request("singup/updateNotifyClickedStatus")
                    }
                }
            }
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        HTUtils.share.checkLogin {
            self.performSegue(withIdentifier: "HTChatList", sender: nil)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if segment.selectedIndex == 0 {
            return .lightContent
        } else {
            return .default
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTBadgeChanged, object: nil)
    }
}
