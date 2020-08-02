//
//  HTChateListHeaderView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/28.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTChateListHeaderView: UIView {

    @IBOutlet weak var commentBadge: UILabel!
    @IBOutlet weak var atBadge: UILabel!
    @IBOutlet weak var favBadge: UILabel!
    @IBOutlet weak var funsBadge: UILabel!
    @IBOutlet weak var notiBadge: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let oneView = UINib(nibName: "HTChateListHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        oneView.frame = bounds
        addSubview(oneView)
        configView()
        NotificationCenter.default.addObserver(self, selector: #selector(configView), name: .HTBadgeChanged, object: nil)
    }
    
    @objc func configView() {
        DispatchQueue.main.async {
            let funs = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FUNS) ?? 0
            let fav = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_FAV) ?? 0
            let at = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_AT) ?? 0
            let comment = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_COMMENT) ?? 0
            let noti1 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId: BADGE_APPLY_ARCHOR) ?? 0
            let noti2 = RCIMClient.shared()?.getUnreadCount(.ConversationType_PRIVATE, targetId:BADGE_ACTIVITY_DATE_NOTICE) ?? 0
            let noti = noti1 + noti2
            self.funsBadge.isHidden = funs <= 0
            self.funsBadge.text = "\(funs)"
            self.favBadge.isHidden = fav <= 0
            self.favBadge.text = "\(fav)"
            self.atBadge.isHidden = at <= 0
            self.atBadge.text = "\(at)"
            self.commentBadge.isHidden = comment <= 0
            self.commentBadge.text = "\(comment)"
            self.notiBadge.isHidden = noti <= 0
            self.notiBadge.text = "\(noti)"
        }
        
    }

    @IBAction func funsAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTClubMemberViewController") as! HTClubMemberViewController
        vc.type = .funs
        vc.title = "粉丝"
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_FUNS)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }
    
    @IBAction func favAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
        vc.vm.type = "4"
        vc.title = "赞"
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
       RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_FAV)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }
    
    @IBAction func atAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
        vc.vm.type = "2"
        vc.title = "@我"
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_AT)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTFavListViewController") as! HTFavListViewController
        vc.vm.type = "3"
        vc.title = "评论"
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_COMMENT)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }
    
    @IBAction func notiAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTNotificationViewController") as! HTNotificationViewController
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_APPLY_ARCHOR)
        RCIMClient.shared()?.clearMessagesUnreadStatus(.ConversationType_PRIVATE, targetId: BADGE_ACTIVITY_DATE_NOTICE)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTBadgeChanged, object: nil)
    }

}
