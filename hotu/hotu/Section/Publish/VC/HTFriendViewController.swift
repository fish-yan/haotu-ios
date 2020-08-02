//
//  HTFriendViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTFriendViewController: UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var contactTableView: UITableView!
    
    @IBOutlet weak var segment: FYSegment!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var cntSearchTF: UITextField!
    private var friendDateSource: HTFriendDataSource!
    
    private var isTapSegment = false
    
    private var vm = HTFriendVM()
    
    var complete: ((HTMemberModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        request()
        firstRequest()
    }
    
    private func configView() {
        segment.titleArray = ["好友", "通讯录"]
        segment.selectAction = { [weak self] index in
            self?.isTapSegment = true
            self?.contentScrollView.setContentOffset(CGPoint(x: CGFloat(index) * SCREEN_WIDTH, y: 0), animated: true)
            self?.firstRequest()
            
        }
        friendDateSource = HTFriendDataSource(friendTableView)
        friendDateSource.reloadData = {
            self.friendTableView.mj_header?.beginRefreshing()
        }
        friendDateSource.didSelectRow = { (indexPath, model) in
            if let c = self.complete {
                c(model)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func firstRequest() {
        if segment.selectedIndex == 0 {
            if vm.memberList.isEmpty {
                friendTableView.mj_header?.beginRefreshing()
            }
        } else {
            if vm.contacts.isEmpty {
                contactTableView.mj_header?.beginRefreshing()
            }
        }
    }
    
    private func request() {
        friendTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestFrient()
        })
        contactTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestContacts()
        })
    }
    
    private func requestFrient() {
        vm.keyword = searchTF.text ?? ""
        vm.requestGetFrend { [weak self] (success) in
            self?.friendTableView.mj_header?.endRefreshing()
            self?.friendTableView.reloadData()
            self?.friendDateSource.resetData(self?.vm.memberList)
        }
    }
    
    private func requestContacts() {
        vm.key = cntSearchTF.text ?? ""
        vm.requestContact { (success) in
            self.contactTableView.mj_header?.endRefreshing()
            self.contactTableView.reloadData()
        }
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

extension HTFriendViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        let contact = vm.contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName)\(contact.familyName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = vm.contacts[indexPath.row]
        let name = "\(contact.givenName)\(contact.familyName)"
        if contact.phoneNumbers.count > 1 {
            let alert = UIAlertController(title: "选择号码", message: nil, preferredStyle: .actionSheet)
            for phone in contact.phoneNumbers {
                let tel = phone.value.stringValue
                let action = UIAlertAction(title: tel, style: .default) { (action) in
                    if let c = self.complete {
                        let model = HTMemberModel()
                        model.nick_name = name
                        model.tel = tel
                        c(model)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                alert.addAction(action)
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        } else {
            if let c = complete,
                let tel = contact.phoneNumbers.first?.value.stringValue {
                let model = HTMemberModel()
                model.nick_name = name
                model.tel = tel
                c(model)
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
}

extension HTFriendViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            isTapSegment = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            if !isTapSegment {
                segment.process = contentScrollView.contentOffset.x / contentScrollView.contentSize.width
            }
        }
    }
}

extension HTFriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTF {
            friendTableView.mj_header?.beginRefreshing()
        } else {
            contactTableView.mj_header?.beginRefreshing()
        }
        return true
    }
}
