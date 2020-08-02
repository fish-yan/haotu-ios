//
//  HTSearchVM.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/13.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchVM: NSObject {
    
    private let historyKey = "historyKey"
    
    var keyword = ""
    
    var searchHotKeys = [HTSearchKeyModel]()
    
    var historys: [String] {
        let ud = UserDefaults.standard
        if let arr = ud.array(forKey: historyKey) as? [String] {
            return Array<String>(arr.prefix(5))
        }
        return [String]()
    }
    
    func requestHotSearchKey(complete: @escaping(Bool)->Void) {
        FYNetWork.request(SEAARCH_HOT_KEY, params: [:], isLoading: false).responseJSON { (response: HTBaseModel<[HTSearchKeyModel]>) in
            if let d = response.data {
                self.searchHotKeys = d
            }
            complete(true)
        }
    }
    
    func requestAddSearchKey() {
        addHistory()
        let params = ["keyword": keyword]
        FYNetWork.request(ADD_SEARCH_KEY, params: params, isLoading:  false).responseJSON { (response: HTBaseModel<String>) in
        }
    }
    
    func addHistory() {
        delete(keyword)
        let ud = UserDefaults.standard
        var arr = historys
        arr.insert(keyword, at: 0)
        ud.set(arr, forKey: historyKey)
    }
    
    func delete(_ text: String) {
        var arr = historys
        arr.removeAll(where: {$0 == text})
        let ud = UserDefaults.standard
        ud.set(arr, forKey: historyKey)
    }
    
}
