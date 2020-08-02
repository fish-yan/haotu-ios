//
//  HTLiveMsgView.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/23.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import RongIMKit
import YYText

class HTLiveMsgView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTV: HTMsgTFView!
        
    let cellKey = "HTLiveMsgCell"
    
    private var roomId = ""
    
    private var dataSource = [RCTextMessage]()
    
    var timer: Timer?
    
    var atMemberList = [HTMemberModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    func loadView() {
        backgroundColor = .clear
        let glayer = CAGradientLayer()
        glayer.frame = bounds
        glayer.startPoint = CGPoint(x: 0, y: 0)
        glayer.endPoint = CGPoint(x:0, y:1)
        glayer.colors = [UIColor(white: 0, alpha: 0.2).cgColor, UIColor.black.cgColor]
        layer.insertSublayer(glayer, at: 0)
        let v = UINib(nibName: "HTLiveMsgView", bundle: nil).instantiate(withOwner: self, options: nil).last as! UIView
        v.frame = bounds
        v.backgroundColor = .clear
        addSubview(v)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        msgTV.msgTV.placeholderTextColor = .white
        msgTV.msgTV.textColor = .white
        msgTV.msgTV.delegate = self
        msgTV.msgTV.tColor = UIColor.white
        msgTV.atAction = {
            let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTClubMemberViewController") as! HTClubMemberViewController
            vc.type = .all
            vc.title = "好友"
            vc.complete = { model in
                self.atMemberList.append(model)
                var text = self.msgTV.text
                text += "@\(model.nick_name) "
                self.msgTV.text = text
                self.msgTV.becomeFirstResponder()
            }
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func configChatRoom(_ targetId: String) {
        roomId = targetId
        RCIMClient.shared()?.joinChatRoom(targetId, messageCount: -1, success: {
            RCIMClient.shared()?.setReceiveMessageDelegate(self , object: nil)
        }, error: { (code) in
            print(code)
        })
    }
    
    func exitChatRoom() {
        RCIMClient.shared()?.quitChatRoom(roomId, success: {
            
        }, error: { (code) in
            print(code)
        })
    }
    
    private func sendMsg(_ content: String) {
        endEditing(true)
        let ids = atMemberList.map({$0.id})
        let msg = RCTextMessage(content: content)
        let mentionInfo = RCMentionedInfo(mentionedType: .mentioned_Users, userIdList:ids, mentionedContent: content)
        msg?.mentionedInfo = mentionInfo
        msg?.senderUserInfo = RCIM.shared()?.currentUserInfo
        RCIMClient.shared()?.sendMessage(.ConversationType_CHATROOM, targetId: roomId, content: msg, pushContent: nil, pushData: nil, success: { (msgId) in
            DispatchQueue.main.async {
                if let m = msg {
                    self.msgTV.text = ""
                    self.dataSource.append(m)
                    self.configOffset()
                }
            }
        }, error: { (code, msgId) in
            print(code)
        })
    }
    
    private func configOffset() {
        tableView.reloadData()
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.tableView.scrollToRow(at: IndexPath(row: self.dataSource.count - 1, section: 0), at: .bottom, animated: true)
            self.timer?.invalidate()
            self.timer = nil
        })
    }

}

extension HTLiveMsgView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as! HTLiveMsgCell
        let content = dataSource[indexPath.row]
        if let userinfo = content.senderUserInfo {
            cell.nmLab.text = userinfo.name
        }
        cell.detailLab.text = content.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension HTLiveMsgView: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        if textView.text.count > 100 {
            textView.text = textView.text.subString(from: 0, to: 100)
            Toast("评论最多100字")
        }
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            HTUtils.share.checkLogin {
                self.sendMsg(textView.text)
            }
        }
        return true
    }

}

extension HTLiveMsgView: RCIMClientReceiveMessageDelegate {
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        if message.conversationType == .ConversationType_CHATROOM,
            let msg = message.content as? RCTextMessage {
            DispatchQueue.main.async {
                self.dataSource.append(msg)
                self.configOffset()
            }
        }
    }
    
}
