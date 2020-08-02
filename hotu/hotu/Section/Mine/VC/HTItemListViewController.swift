//
//  HTItemListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/5.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var code = ""
    var complete: ((HTItemModel)->Void)?
    
    private var dataSource = [HTItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    private func request() {
        HTAppVM.share.requestItemList(code: code) { (data) in
            if let d = data {
                self.dataSource = d
                self.tableView.reloadData()
            }
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

extension HTItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].itemName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let c = complete {
            c(dataSource[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}
