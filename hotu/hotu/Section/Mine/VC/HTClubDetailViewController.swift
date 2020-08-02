//
//  HTClubDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTClubDetailViewController: UIViewController {
    @IBOutlet var headerImgs: [UIImageView]!
    
    @IBOutlet var addImgs: [UIImageView]!
    
    @IBOutlet var userLabs: [UILabel]!
    
    @IBOutlet weak var bottomBtn: UIButton!
    
    @IBOutlet weak var clubNmLab: UILabel!
    @IBOutlet weak var bottomH: NSLayoutConstraint!
    
    @IBOutlet weak var ignoreSwitch: UISwitch!
    var vm = HTClubVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    private func configView() {
        bottomBtn.isHidden = vm.model.userId == HTUserInfo.share.userId
        bottomH.constant = vm.model.userId == HTUserInfo.share.userId ? 0 : 69
        if vm.memberList.filter({$0.user_id == HTUserInfo.share.userId}).isEmpty {
            bottomBtn.isHidden = true
            bottomH.constant = 0
        }
        let showList = vm.memberList.prefix(headerImgs.count - 1)
        addImgs.forEach({$0.isHidden = true})
//        addImgs[showList.count].isHidden = false
        for (i, imgV) in headerImgs.enumerated() {
            if i < showList.count {
                let model = showList[i]
                imgV.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            } else {
                imgV.image = nil
            }
        }
        for (i, lab) in userLabs.enumerated() {
            if i < showList.count {
                let model = showList[i]
                lab.text = model.nick_name
            } else {
                lab.text = ""
            }
        }
        clubNmLab.text = vm.model.group_name
        
    }
    
    private func request() {
        vm.requestClubDetail { (success) in
            self.configView()
        }
        vm.requestClubMemberList { (success) in
            self.configView()
        }
        RCIMClient.shared()?.getConversationNotificationStatus(.ConversationType_GROUP, targetId: vm.model.group_id, success: { (status) in
            DispatchQueue.main.async {
                self.ignoreSwitch.isOn = status == .DO_NOT_DISTURB
            }
        }, error: { (error) in
            print(error)
        })
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let imgV = headerImgs[sender.tag]
        if imgV.image != nil {return}
        
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        performSegue(withIdentifier: "HTClubMember", sender: HTMemberListType.group)
    }
    
    @IBAction func ignoreMsgAction(_ sender: UISwitch) {
        RCIMClient.shared()?.setConversationNotificationStatus(.ConversationType_GROUP, targetId: vm.model.group_id, isBlocked: sender.isOn, success: { (status) in
            DispatchQueue.main.async {
                self.ignoreSwitch.isOn = status == .DO_NOT_DISTURB
            }
        }, error: { (error) in
            print(error)
        })
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        if vm.model.userId == HTUserInfo.share.userId {
            return
        }
        vm.requestExitClub { (success) in
            if let vc = self.navigationController?.viewControllers.filter({$0 is HTChatListViewController}).first as? HTChatListViewController {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTAnnouncement" {
            let vc = segue.destination as! HTAnnouncementViewController
            vc.vm = vm
        } else if segue.identifier == "HTClubQrCode" {
            let vc = segue.destination as! HTClubQrCodeViewController
            vc.logo = vm.model.group_logo
            vc.name = vm.model.group_name
            vc.qrcode = vm.model.qrCode
        } else if segue.identifier == "HTClubMember" {
            let vc = segue.destination as! HTClubMemberViewController
            vc.clubVM.model.group_id = vm.model.group_id
            if let type = sender as? HTMemberListType {
                vc.type = type
            }
        }
    }

}
