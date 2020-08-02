//
//  HTCommentViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import IQKeyboardManager
import YYText

class HTCommentViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
//    @IBOutlet weak var emojiBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
//    @IBOutlet weak var emojiView: HTEmojiView!
        
//    @IBOutlet weak var msgTV: HTAttTextView!
    
    @IBOutlet weak var msgTV: HTMsgTFView!
    
    var vm = HTCommentVM()
    
    var complete:((Int)->Void)?
    
    private var currentSection = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.vm.page += 1
            self.request()
        })
        self.request()
        addObserver()
        configView()
    }
    
    private func configView() {
        msgTV.msgTV.delegate = self
        msgTV.emojiAction = { height in
            self.view.endEditing(true)
            self.bottomHeight.constant = height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        msgTV.atAction = {
            let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTClubMemberViewController") as! HTClubMemberViewController
            vc.type = .all
            vc.title = "好友"
            vc.complete = { model in
                self.vm.atMemberList.append(model)
                var text = self.msgTV.text
                text += "@\(model.nick_name) "
                self.msgTV.text = text
                self.msgTV.becomeFirstResponder()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func request() {
        vm.request { [weak self] (success) in
            self?.titleLab.text = "\(self!.vm.total)条评论"
            if self!.vm.nomore {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.mj_footer?.endRefreshing()
            }
            self?.tableView.reloadData()
        }
    }
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        if let com = complete {
            com(vm.total)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let bh: CGFloat = UIApplication.shared.statusBarFrame.height == 20 ? 0 : 34
            bottomHeight.constant = rect.height + 50 - bh
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardHidden(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            bottomHeight.constant = 50
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func sendComment() {
        view.endEditing(true)
        vm.requestAddComment { (model) in
            if model.parentId == "0" {
                self.vm.dataSource.insert(model, at: 0)
            } else {
                if self.vm.dataSource[self.currentSection].subCommentList.count <= 1 {
                    self.vm.dataSource[self.currentSection].openType = .finish
                }
                self.vm.dataSource[self.currentSection].subCommentList.insert(model, at: 0)
            }
            self.tableView.reloadData()
            self.msgTV.text = ""
            self.vm.commentId = "0"
            self.vm.total += 1
            self.titleLab.text = "\(self.vm.total)条评论"
            NotificationCenter.default.post(name: .HTCommentChanged, object: 1)
        }
    }
    
    private func getHeaderHeight(_ section: Int) -> CGFloat {
        let model = vm.dataSource[section]
        let width: CGFloat = SCREEN_WIDTH - 76
        let height = model.content.sh_heightForComment(fontSize: 14, width: width)
        return 50 + height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == view {
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HTCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = vm.dataSource[section]
        if (model.openType == .close || model.openType == .finishClose) && model.subCommentList.count > 1 {
            return 1
        } else {
            return model.subCommentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTCommentCell", for: indexPath) as! HTCommentCell
        let model = vm.dataSource[indexPath.section].subCommentList[indexPath.row]
        cell.parent = vm.dataSource[indexPath.section].id
        cell.model = model
        cell.auLab.isHidden = model.userId != vm.videoModel.userId
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = vm.dataSource[section]
        if model.commentNum > 0 && model.subCommentList.count == 0 {
            model.subPage = 1
            vm.requestSubCommentList(index: section) { (success) in
                if model.commentNum == model.subCommentList.count {
                    model.openType = .finishClose
                }
                tableView.reloadSections([section], with: .automatic)
            }
        }
        let header = HTCommentHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: getHeaderHeight(section)))
        header.auLab.isHidden = vm.dataSource[section].userId != vm.videoModel.userId
        header.model = model
        header.btnAction = { btn in
            if self.vm.commentId != model.id {
                self.msgTV.text = ""
            }
            self.currentSection = section
            self.msgTV.placeholderText = "回复@\(model.nickName)"
            self.vm.commentId = model.id
            self.msgTV.becomeFirstResponder()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = vm.dataSource[section]
        let footer = HTCommentFooterView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        footer.clipsToBounds = true
        footer.count = model.commentNum
        footer.openType = model.openType
        footer.moreAction = { btn in
            switch model.openType {
            case .close, .open:
                model.subPage += 1
                self.vm.requestSubCommentList(index: section) { (success) in
                    if model.commentNum <= model.subCommentList.count {
                        model.openType = .finish
                    } else {
                        model.openType = .open
                    }
                    tableView.reloadSections([section], with: .automatic)
                }
            case .finish:
                model.openType = .finishClose
                tableView.reloadSections([section], with: .automatic)
            case .finishClose:
                model.openType = .finish
                tableView.reloadSections([section], with: .automatic)
            }
            
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = vm.dataSource[indexPath.section].subCommentList[indexPath.row]
        if vm.commentId != model.id {
            msgTV.text = ""
        }
        currentSection = indexPath.section
        vm.commentId = model.id
        msgTV.placeholderText = "回复@\(model.nickName)"
        msgTV.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getHeaderHeight(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let model = vm.dataSource[section]
        if model.subCommentList.count <= 1 {
            return 0.01
        }
        return 40
    }
}

extension HTCommentViewController: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        if textView.text.count > 100 {
            textView.text = textView.text.subString(from: 0, to: 100)
            Toast("评论最多100字")
        }
        vm.content = textView.text
    }
    
    func textViewDidEndEditing(_ textView: YYTextView) {
        if textView.text.isEmpty {
            vm.commentId = "0"
            msgTV.placeholderText = "支持一下吧~"
        }
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            HTUtils.share.checkLogin {
                self.sendComment()
            }
        }
        return true
    }

}
