//
//  HTPolicyDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPolicyDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellKey = "HTPolicyCell"
    
    private var tableView: UITableView!
    
    private var dataSource: [HTPolicyModel] = []

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
    
    func resetData(_ data: [HTPolicyModel]?) {
        if let d = data {
            self.dataSource = d
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTPolicyCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
