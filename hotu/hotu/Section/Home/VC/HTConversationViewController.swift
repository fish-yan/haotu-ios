//
//  HTConversationViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/15.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit
import IQKeyboardManager
import SwiftyJSON

class HTConversationViewController: RCConversationViewController {
    
    var vm = HTClubVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        configRight()
        setbackItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configRight()
        setbackItem()
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configRight()
        setbackItem()
        vm.model.group_id = targetId
        if title?.isEmpty != true {
            vm.requestClubDetail(false) { [weak self] (success) in
                self?.title = self?.vm.model.group_name
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMsg), name: .HTReceivedMsg, object: nil)
    }
    
    override func notifyUpdateUnreadMessageCount() {
        super.notifyUpdateUnreadMessageCount()
        configRight()
        setbackItem()
    }
    
    @objc func receiveMsg() {
        configRight()
        setbackItem()
    }
    
    private func configRight() {
        DispatchQueue.main.async {
            let rightItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(self.rightItemAction))
            rightItem.tintColor = .black
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    @objc func rightItemAction() {
        let story = UIStoryboard(name: "Mine", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HTClubDetail2ViewController") as! HTClubDetail2ViewController
        vc.clubVM.model.group_id = targetId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didTapCellPortrait(_ userId: String!) {
        let story = UIStoryboard(name: "Mine", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HTMineViewController") as! HTMineViewController
        vc.hidesBottomBarWhenPushed = true
        vc.mineVM.userId = userId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        guard let rtMsg = model.content as? RCTextMessage else {return}
        let dict = HTUtils.share.transformJSONObject(rtMsg.extra)
        if let type = dict["type"] as? String,
            let activityId = dict["activityId"] {
            let story = UIStoryboard(name: "Home", bundle: nil)
            if type == "RC:activity" || type == "RC:memberAdd" {
                let vc = story.instantiateViewController(withIdentifier: "HTActivityDetailViewController") as! HTActivityDetailViewController
                vc.vm.model.activityId = "\(activityId)"
                navigationController?.pushViewController(vc, animated: true)
            } else if type == "RC:match" {
                let vc = story.instantiateViewController(withIdentifier: "HTMatchDetailViewController") as! HTMatchDetailViewController
                vc.vm.model.activityId = "\(activityId)"
                navigationController?.pushViewController(vc, animated: true)
            } else if type == "RC:live" {
                let st = UIStoryboard(name: "Mine", bundle: nil)
                let vc = st.instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
                vc.vm.activityId =  "\(activityId)"
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTReceivedMsg, object: nil)
    }

}
