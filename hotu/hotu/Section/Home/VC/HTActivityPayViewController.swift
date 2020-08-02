//
//  HTActivityPayViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTActivityPayViewController: UIViewController {
    
    @IBOutlet weak var womenPriceLab: UILabel!
    @IBOutlet weak var manPriceLab: UILabel!
    
    @IBOutlet weak var manCountV: FYNumView!
    
    @IBOutlet weak var womenCountV: FYNumView!
    
    @IBOutlet weak var totalPriceLab: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let adKey = "HTAdCell"

    var vm = HTActivityVM()
        
    var payInfo = HTActivityPayInfoModel()
    
    var safeStr = ""
    
    var totalPrice: Double = 0
    
    var isCloseAd = false
    
    var ad: HTItemModel?
    
    var isMatch = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPayInfo()
        requestAd()
        tableView.register(UINib(nibName: adKey, bundle: nil), forCellReuseIdentifier: adKey)
    }
    
    private func configView() {
        manPriceLab.text = "\(payInfo.manPice)元/位"
        womenPriceLab.text = "\(payInfo.womanPrice)元/位"
        let max = Double(vm.model.total_no) ?? 0.0
        manCountV.set(0, min: 0, max: max, space: 1)
        womenCountV.set(0, min: 0, max: max, space: 1)
        
        totalPriceLab.text = "0元"
        manCountV.numChanged = { [weak self] num in
            let n = Double(num) ?? 0.0
            let wn = self?.womenCountV.num ?? 0
            let min = Swift.min(wn, max - n)
            self?.womenCountV.set(min, min: 0, max: max - n, space: 1)
            self?.configTotalPirce()
        }
        womenCountV.numChanged = { [weak self] num in
            let n = Double(num) ?? 0.0
            let wn = self?.manCountV.num ?? 0
            let min = Swift.min(wn, max - n)
            self?.manCountV.set(min, min: 0, max: max - n, space: 1)
            self?.configTotalPirce()
        }
    }
    
    func configTotalPirce() {
        totalPrice = 0
        safeStr = ""
        let manPrice = Double(payInfo.manPice) ?? 0.0
        let womanPrice = Double(payInfo.womanPrice) ?? 0.0
        let manTotal = manPrice * manCountV.num
        let womenTotal = womanPrice * womenCountV.num
        totalPrice = manTotal + womenTotal
        var arr = [String]()
        for item in payInfo.safeList {
            let itemPrice = Double(item.ext) ?? 0.0
            totalPrice += itemPrice * item.count
            if item.count > 0 {
                arr.append("\(item.itemCode):\(Int(item.count))")
            }
        }
        safeStr = arr.joined(separator: ",")
        totalPriceLab.text = "\(totalPrice)元"
        vm.model.totalPrice = "\(totalPrice)"
    }
    
    func requestAd() {
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_ACTIVITY_PAY") { (items) in
            if let item = items?.first {
                self.ad = item
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func payAction(_ sender: UIButton) {
        requestPay { (success) in
            if success {
                self.performSegue(withIdentifier: "HTActivityPayResultViewController", sender: nil)
                if self.isMatch {
                    NotificationCenter.default.post(name: .HTMatchChanged, object: true)
                } else {
                    NotificationCenter.default.post(name: .HTActivityChanged, object: true)
                }
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTActivityPayResultViewController" {
            let vc = segue.destination as! HTActivityPayResultViewController
            vc.vm = vm
        }
    }

}

extension HTActivityPayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return payInfo.payList.count
        } else {
            return (ad == nil || isCloseAd) ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HTPayCell", for: indexPath) as! HTPayCell
            let model = payInfo.payList[indexPath.row]
            cell.numView.isHidden = true
            cell.titleLab.text = model.itemName
            cell.desLab.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: adKey, for: indexPath) as! HTAdCell
            cell.img.sd_setImage(with: URL(string: ad?.itemName ?? ""), completed: nil)
            cell.closeAction = {
                self.isCloseAd = true
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HTPayHeader(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        if section == 0 {
            header.titleLab.text = "支付方式"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 69
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if !ad!.ext.isEmpty {
                HTUtils.share.checkLogin {
                    FYWebViewController.open(self.ad!.ext)
                }
            }
        }
    }
}

extension HTActivityPayViewController {
    func requestPayInfo() {
        let params = ["activity_id": vm.model.activityId]
        FYNetWork.request(ACTIVITY_PAY_INFO, params: params).responseJSON { (response: HTBaseModel<HTActivityPayInfoModel>) in
            if let d = response.data {
                self.payInfo = d
            }
            self.configView()
            self.tableView.reloadData()
        }
    }
    
    func requestPay(complete: @escaping(Bool)->Void) {
        guard checkPayParams() else { return }
        var params = ["activity_id": vm.model.activityId,
                      "payType": "1",
                      "totalAmount": "\(totalPrice)",
                      "manNumber": "\(Int(manCountV.num))",
                      "womanNumber": "\(Int(womenCountV.num))"]
        if !safeStr.isEmpty {
            params["safeStr"] = safeStr
        }
        FYNetWork.request(SIGN_UP_ACTIVITY, params: params).responseJSON { (response: HTBaseModel<HTActivityPayResultModel>) in
            if self.totalPrice > 0 {
                if let d = response.data {
                    HTWXUtil.share.pay(with: d.payInfo) { (success) in
                        complete(success)
                    }
                }
            } else {
                complete(true)
            }
        }
    }
    
    private func checkPayParams() -> Bool {
        if manCountV.num == 0 && womenCountV.num == 0  {
            Toast("报名人数至少1人")
            return false
        }
        return true
    }
}
