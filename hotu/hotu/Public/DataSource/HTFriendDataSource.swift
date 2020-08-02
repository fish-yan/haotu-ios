//
//  HTUserDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit


class HTFriendDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellKey = "HTFriendCell"
    
    private var tableView: UITableView!
    
    private var dataSource: [HTMemberModel] = []
    
    var didSelectRow: ((IndexPath, HTMemberModel)->Void)?
    
    var reloadData: (()->Void)?

    init(_ tabV: UITableView) {
        super.init()
        tableView = tabV
        configTableView()
    }
    
    private func configTableView() {
        tableView.backgroundColor = UIColor(hex: 0xF7F7F7)
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func resetData(_ data: [HTMemberModel]?) {
        if let d = data {
            dataSource = d;
            tableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTFriendCell
        cell.model = dataSource[indexPath.row]
        cell.reloadData = reloadData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        let story = UIStoryboard(name: "Mine", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HTMineViewController") as! HTMineViewController
        vc.hidesBottomBarWhenPushed = true
        vc.mineVM.userId = model.user_id
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
