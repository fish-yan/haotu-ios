//
//  HTProductDataSource.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTProductDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellKey = "HTProductCell"
    
    private var tableView: UITableView!
    
    private var dataSource: [HTProductModel] = []
    
    var didSelectRow: ((IndexPath, HTProductModel)->Void)?

    init(_ tabV: UITableView) {
        super.init()
        tableView = tabV
        configTableView()
    }
    
    private func configTableView() {
        tableView.estimatedRowHeight = 135
        tableView.backgroundColor = UIColor(hex: 0xF7F7F7)
        tableView.register(UINib(nibName: cellKey, bundle: nil), forCellReuseIdentifier: cellKey)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func resetData(_ data: [HTProductModel]?) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellKey, for: indexPath) as! HTProductCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let select = didSelectRow {
            select(indexPath, model)
            return
        }
        let story = UIStoryboard(name: "Home", bundle: nil)
        if model.type == "1" {
            let vc = story.instantiateViewController(withIdentifier: "HTProductDetailViewController") as! HTProductDetailViewController
            vc.vm.productId = model.id
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = story.instantiateViewController(withIdentifier: "HTCourseDetailViewController") as! HTCourseDetailViewController
            vc.vm.productId = model.id
            visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
