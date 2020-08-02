//
//  HTChatListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/28.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTChatListViewController: RCConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        self.conversationListTableView.separatorStyle = .none
        self.emptyConversationView.frame.origin.y = 200 * SCREEN_WIDTH / 375;
        let headerView = HTChateListHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90))
        self.conversationListTableView.tableHeaderView = headerView
        setDisplayConversationTypes([NSNumber(value: RCConversationType.ConversationType_GROUP.rawValue)])
    }
    
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        performSegue(withIdentifier: "HTConversation", sender: model)
        NotificationCenter.default.post(name: .HTBadgeChanged, object: nil)
    }

    override func didDeleteConversationCell(_ model: RCConversationModel!) {
        RCIMClient.shared()?.clearMessages(model.conversationType, targetId: model.targetId)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func qrCodeAction(_ sender: UIBarButtonItem) {
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTConversation" {
            let vc = segue.destination as! HTConversationViewController
            if let model = sender as? RCConversationModel {
                vc.conversationType = model.conversationType
                vc.title = model.conversationTitle
                vc.targetId = model.targetId
            }
        } else if segue.identifier == "HTQRCodeScan" {
            let vc = segue.destination as! HTQRCodeScanViewController
            vc.complete = { success in
                
            }
        }
    }
    

}
