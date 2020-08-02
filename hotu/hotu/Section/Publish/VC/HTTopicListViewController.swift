//
//  HTTopicListViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/10.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTTopicListViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var complete:((HTTopicModel)->Void)?
    
    private var dataSource = [HTTopicModel]()
    
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.requestTopicList()
        })
        tableView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.page += 1
            self.requestTopicList()
        })
        tableView.mj_header?.beginRefreshing()
    }
    
    @IBAction func addTopicAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "新增话题", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            if let tf = alert.textFields?.first,
                let text = tf.text,
                !text.isEmpty {
                self.requestAddTopic(content: text)
                alert.dismiss(animated: true, completion: nil)
            } else {
                Toast("请填写话题内容")
            }
        }
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addTextField { (tf) in
            tf.backgroundColor = .white
            tf.borderStyle = .none
            let y = tf.frame.minY - (40 - tf.frame.height) / 2
            tf.frame = CGRect(x: tf.frame.minX, y: y, width: tf.frame.width, height: 40)
            tf.layer.cornerRadius = tf.frame.height / 2
        }
        alert.addAction(action)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
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

extension HTTopicListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        let text = dataSource[indexPath.row].content
        cell.textLabel?.text = "#\(text)#"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let c = complete {
            c(dataSource[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}

extension HTTopicListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.mj_header?.beginRefreshing()
        return true
    }
}

extension HTTopicListViewController {
    func requestTopicList() {
        let params = ["search": searchTF.text ?? "",
                      "sorttype":"1",
                      "page":"\(page)",
                      "size":"20"]
        FYNetWork.request(TOPIC_LIST, method: .get, params: params, isLoading: false).responseJSON { (response: HTBaseModel<[HTTopicModel]>) in
            if self.page == 1 {
                self.dataSource = [HTTopicModel]()
            }
            if let d = response.data {
                self.dataSource += d
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func requestAddTopic(content: String) {
        let params = ["content": content]
        FYNetWork.request(ADD_TOPIC, params: params).responseJSON { (response: HTBaseModel<HTTopicModel>) in
            self.tableView.mj_header?.beginRefreshing()
        }
    }
}
