//
//  HTFriendVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/8.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import Contacts

class HTFriendVM: NSObject {
    
    var memberList = [HTMemberModel]()
    
    var contacts = [CNContact]()
        
    var key = ""
    
    var keyword = ""

    func requestGetFrend(complete: @escaping(Bool)->Void) {
        FYNetWork.request(MY_FRIEND, params: [:], isLoading: false).responseJSON { (response: HTBaseModel<[HTMemberModel]>) in
            if let d = response.data {
                self.memberList = d
            }
            complete(true)
        }.failure { (error) in
            complete(false)
        }
    }
    
    func requestContact(complete: @escaping(Bool)->Void) {
        requestGetCanVisitContact { (success) in
            if success {
                self.requestContactFriend(complete: complete)
            } else {
                Toast("未开启通讯录访问权限")
                complete(false)
            }
        }
    }
    
    func requestContactFriend(complete: @escaping(Bool)->Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (success, error) in
            if success {
                let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor]
                do {
                    self.contacts = [CNContact]()
                    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
                    try store.enumerateContacts(with: request, usingBlock: { (contact, pointer) in
                        if contact.isKeyAvailable(CNContactPhoneNumbersKey) && !contact.phoneNumbers.isEmpty {
                            let fullName = contact.familyName + contact.givenName
                            if fullName.contains(self.key) || self.key.isEmpty {
                                self.contacts.append(contact)
                            }
                        }
                    })
                    DispatchQueue.main.async {
                        complete(true)
                    }
                } catch let error {
                    print(error)
                }
            } else {
                Toast("请允许访问通讯录")
            }
        }
    }
    
    func requestGetCanVisitContact(complete: @escaping(Bool)->Void) {
        FYNetWork.request(GET_VISIT_CONTACT, params: [:], isLoading: false).responseJSON { (json) in
            let isAgree = json["data"]["isAcceptMailList"].stringValue
            complete(isAgree == "1")
        }.failure { (error) in
            complete(false)
        }
    }
}
