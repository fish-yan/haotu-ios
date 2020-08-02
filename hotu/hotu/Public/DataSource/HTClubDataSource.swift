//
//  HTClubDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

enum HTClubDataSourceType {
    case club
    case merc
    case coach
}

class HTClubDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellKey = "HTMercCell"
    
    private var tableView: UITableView!
    
    private var dataSource = [HTClubModel]()
    
    var didSelectRow: ((IndexPath, HTClubModel)->Void)?
    
    var type = HTClubDataSourceType.club

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
    
    func resetData(_ data: [HTClubModel]?) {
        if let d = data {
            dataSource = d
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTMercCell
        cell.type = type
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        let story = UIStoryboard(name: "Mine", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "HTClubDetail2ViewController") as! HTClubDetail2ViewController
        vc.clubVM.model.group_id = model.group_id
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
