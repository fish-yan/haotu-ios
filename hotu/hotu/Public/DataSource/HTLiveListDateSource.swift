//
//  HTLiveListDateSource.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/21.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveListDateSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    private let cellKey = "HTLiveListCell"
    
    private let adKey = "HTAdCell"
    
    private var tableView: UITableView!
    
    private var dataSource = [HTVideoModel]()
    
    var didSelectRow: ((IndexPath, HTVideoModel)->Void)?
    
    var hasAd = true
    
    var isCloseAd = false
    
    var ad: HTVideoModel?
    
    var page = 0
    
    var refresh: ((Int, @escaping ([HTVideoModel]?)->Void)->Void)?

    init(_ tabV: UITableView) {
        super.init()
        tableView = tabV
        configTableView()
    }
    
    private func configTableView() {
        tableView.estimatedRowHeight = 155
        tableView.backgroundColor = UIColor(hex: 0xF7F7F7)
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        tableView.register(UINib(nibName: adKey, bundle: nil), forCellReuseIdentifier: adKey)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 0
            if let r = self.refresh {
                r(self.page, self.resetData(_:))
            }
        })
        tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.page += 1
            if let r = self.refresh {
                r(self.page, self.resetData(_:))
            }
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    func refresh(_ complete: @escaping ((Int,@escaping ([HTVideoModel]?)->Void)->Void)) {
        refresh = complete
    }
    
    func resetData(_ data: [HTVideoModel]?) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        if let d = data {
            dataSource = d
            tableView.reloadData()
        }
        if hasAd && !isCloseAd {
            var index = Swift.min(3, self.dataSource.count)
            index = Swift.max(0, index)
            if ad == nil {
                HTAppVM.share.requestAd(code: "ADVERTISEMENT_ACTIVITY_LIST") { (items) in
                    if let item = items?.first {
                        self.ad = HTVideoModel()
                        self.ad!.isAd = true
                        self.ad!.adImg = item.itemName
                        self.ad!.adUrl = item.ext
                        self.dataSource.insert(self.ad!, at: index)
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.dataSource.insert(self.ad!, at: index)
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        if model.isAd {
            let cell = tableView.dequeueReusableCell(withIdentifier: adKey, for: indexPath) as! HTAdCell
            cell.img.sd_setImage(with: URL(string: model.adImg), completed: nil)
            cell.closeAction = {
                self.dataSource.remove(at: self.dataSource.firstIndex(of: model)!)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.isCloseAd = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTLiveListCell
            cell.model = model
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row]
        if model.isAd {
            return 140
        }
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.isAd {
            if !model.adUrl.isEmpty {
                let url = model.adUrl
                FYWebViewController.open(url)
            }
            return
        }
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
        vc.vm.activityId = model.activityId
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
