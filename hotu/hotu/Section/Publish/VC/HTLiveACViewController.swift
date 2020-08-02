//
//  HTLiveACViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/23.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveACViewController: UIViewController {

    @IBOutlet weak var pImgV: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var desLab: UILabel!
    
    private var dataSource: HTActivityDataSource!
    
    var vm = HTActivityVM()
    var callback: (([HTActivityModel]?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = HTActivityDataSource(tableView)
        dataSource.type = 1
        dataSource.didSelectRow = { (indexPath, model) in
            if !model.isSelected {
                self.vm.dataSource.forEach({$0.isSelected = false})
            }
            model.isSelected = !model.isSelected
            self.tableView.reloadData()
        }
        tableView.backgroundColor = UIColor.clear
        request()
    }
    
    func request() {
        dataSource.refresh { (page, callback) in
            self.vm.pageIndex = page
            self.vm.requestLiveACList { (success) in
                self.pImgV.isHidden = !self.vm.dataSource.isEmpty
                callback(self.vm.dataSource)
            }
        }
    }
    
    override func navigationShouldPop() -> Bool {
        dismiss(animated: true, completion: nil)
        return false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTLivePostViewController" {
            let vc = segue.destination as! HTLivePostViewController
            if let model = vm.dataSource.filter({$0.isSelected}).first {
                vc.activityId = model.activityId
                if model.sports_poster.isEmpty {
                    vc.post = model.groupLogo
                } else {
                    vc.post = model.sports_poster
                }
            }
        }
    }

    @IBAction func imgLiveAction(_ sender: UIButton) {
        if let model = vm.dataSource.filter({$0.isSelected}).first {
            vm.model = model
            checkVitify {
                self.checkStatus {
                    self.performSegue(withIdentifier: "HTLivePostViewController", sender: nil)
                }
            }
        } else {
            Toast("请选择需要直播的活动或赛事")
        }
    }
    
    @IBAction func videoLiveAction(_ sender: Any) {
        
    }
    
    func checkVitify(_ complete:@escaping ()->Void) {
        if HTUserInfo.share.isReal {
            complete()
            return
        }
        let vc = UIStoryboard(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "HTLiveAuthViewController") as! HTLiveAuthViewController
        vc.complete = complete
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkStatus(_ complete: @escaping ()->Void) {
        vm.requestGetLiveStatus { (status) in
            if status == "0" || status == "2" {
                Toast("该活动您无法申请为主播")
            } else if status == "1" {
                let alert = FYAlertController(title: "提示", msg: "您未参加这次活动\n需要申请为本场活动做直播", commit: "申请", cancel: "取消")
                alert.action(commit:  {
                    self.vm.requestApplyArchor { (success) in
                        Toast("申请成功")
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                complete()
            }
        }
    }
}
