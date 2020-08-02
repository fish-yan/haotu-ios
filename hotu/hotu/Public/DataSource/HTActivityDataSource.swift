//
//  HTMActivityDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTActivityDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellKey = "HTActivityCell"
    
    private let cell1Key = "HTActivtyListCell"
    
    private let adKey = "HTAdCell"
    
    private var tableView: UITableView!
    
    private var dataSource = [HTActivityModel]()
    
    var refresh: ((Int, @escaping([HTActivityModel]?)->Void)->Void)?
    
    var didSelectRow: ((IndexPath, HTActivityModel)->Void)?
    
    var hasAd = false
    
    var isCloseAd = false
    
    var ad: HTActivityModel?
    
    var page = 0
    
    var type = 0
    
    var hasGroupNm = false
    
    init(_ tabV: UITableView) {
        super.init()
        tableView = tabV
        configTableView()
    }
    
    private func configTableView() {
        tableView.estimatedRowHeight = 172
        tableView.backgroundColor = UIColor(hex: 0xF7F7F7)
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        tableView.register(UINib(nibName: adKey, bundle: nil), forCellReuseIdentifier: adKey)
        tableView.register(UINib(nibName: cell1Key, bundle: nil), forCellReuseIdentifier: cell1Key)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func refresh(_ complete: @escaping ((Int, @escaping ([HTActivityModel]?)->Void)->Void)) {
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
        refresh = complete
    }
    
    func resetData(_ data: [HTActivityModel]?) {
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
                        self.ad = HTActivityModel()
                        self.ad!.isAd = true
                        self.ad!.adImg = item.itemName
                        self.ad!.adTitle = item.title
                        self.ad!.remark = item.remark
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
            if type == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cell1Key, for: indexPath) as! HTActivtyListCell
                cell.type = type
                cell.model = model
                cell.topV.isHidden = !hasGroupNm
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTActivityCell
                cell.type = type
                cell.model = model
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row]
        if model.isAd {
            return 140
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.isAd {
            if !model.adUrl.isEmpty {
                HTUtils.share.checkLogin {
                    FYWebViewController.open(model.adUrl)
                }
            }
            return
        }
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        HTUtils.share.checkLogin {
            let story = UIStoryboard(name: "Home", bundle: nil)
            if model.isPk == "2" {
                if model.stage == "2" || model.stage == "3" {
                    let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
                    vc.vm.activityId = model.activityId
                    visibleViewController?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = story.instantiateViewController(withIdentifier: "HTMatchDetailViewController") as! HTMatchDetailViewController
                    vc.vm.model.activityId = model.activityId
                    visibleViewController?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if model.stage == "2" {
                    let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
                    vc.vm.activityId = model.activityId
                    visibleViewController?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = story.instantiateViewController(withIdentifier: "HTActivityDetailViewController") as! HTActivityDetailViewController
                    vc.vm.model.activityId = model.activityId
                    visibleViewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
