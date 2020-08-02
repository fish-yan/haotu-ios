//
//  HTFavListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/8.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTFavListViewController: UIViewController {
    
 
    @IBOutlet weak var tableView: UITableView!
        
    var vm = HTMsgVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.request()
        })
        tableView.mj_header?.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(msgChanged), name: .HTBadgeChanged, object: nil)
    }
    
    private func request() {
        vm.requestMsg { (success) in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func msgChanged(_ notification: Notification) {
        tableView.mj_header?.beginRefreshing()
    }
    
    private func pushToVideoList(_ data: [HTVideoModel]) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTVideoViewController") as! HTVideoViewController
        vc.vm.dataSource = data
        vc.currentIndexPath = IndexPath(row: 0, section: 0)
        visibleViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTBadgeChanged, object: nil)
    }


}

extension HTFavListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTMsgCommentCell", for: indexPath) as! HTMsgCommentCell
        cell.model = vm.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = vm.dataSource[indexPath.row]
        vm.requestVideoDetail(model.videoId) { (videoModel) in
            self.pushToVideoList([videoModel])
        }
    }
}
