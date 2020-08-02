//
//  HTMatchDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMatchDetailViewController: UIViewController {
    @IBOutlet weak var matchNmLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var endTimeDesLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    var vm = HTActivityVM()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        scrollView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(request), name: .HTMatchChanged, object: nil)
    }
    
    private func configView() {
        scrollView.isHidden = false
        matchNmLab.text = vm.model.activityName
        dateLab.text = vm.model.startTime.formatDate("yyyy-MM-dd HH:mm:ss", to: "yyyy年MM月dd日 HH:mm")
        addressLab.text = vm.model.activityAddress
        typeLab.text = vm.model.projectTypeName
        priceLab.text = vm.model.member_amount + "元"
        totalCount.text = vm.model.group_total_no + "个群"
        imgV.sd_setImage(with: URL(string: vm.model.sports_poster)) { (image, err, type, url) in
            if let img = image {
                let height = SCREEN_WIDTH / img.size.width * img.size.height
                self.imgH.constant = height
            }
        }
        let starDate = Date(vm.model.startTime, formatter: "yyyy-MM-dd HH:mm:ss")
        if let duration = starDate?.timeIntervalSince(Date()) {
            if duration <= 0 {
                endTimeLab.text = "报名已结束"
                endTimeDesLab.text = ""
            } else {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCutdown), userInfo: nil, repeats: true)
                endTimeDesLab.text = "报名截止还有"
                endTimeLab.text = HTUtils.share.getEndTime(Int(duration))
            }
        }
                
        configCommitStatus()
    }
    
    @objc private func request() {
        vm.requestActivityDetail { (success) in
            self.configView()
        }
    }
    
    private func configCommitStatus() {
        
        /// "1";//报名中  "2";//报名结束 "3";//活动结束 "5";//活动暂停 "6";//活动取消 "8"; //活动待退款
        switch vm.model.status  {
        case "1":
            if vm.model.isSigned == "1" {
                signupBtn.setTitle("取消报名", for: .normal)
                signupBtn.setTitle("取消报名", for: .disabled)
            } else {
                signupBtn.setTitle("立即报名", for: .normal)
                signupBtn.setTitle("立即报名", for: .disabled)
            }
            signupBtn.isEnabled = vm.isAgree
        case "2":
            signupBtn.isEnabled = false
            signupBtn.setTitle("报名结束", for: .disabled)
        case "3":
            signupBtn.isEnabled = false
            signupBtn.setTitle("活动结束", for: .disabled)
        case "5":
            signupBtn.isEnabled = false
            signupBtn.setTitle("活动暂停", for: .disabled)
        case "6":
            signupBtn.isEnabled = false
            signupBtn.setTitle("活动取消", for: .disabled)
        case "8":
            signupBtn.isEnabled = false
            signupBtn.setTitle("活动待退款", for: .disabled)
        default:break
        }
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: vm.model.activityAddress, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "百度地图", style: .default) { (action) in
            var urlStr = "baidumap://map/direction?origin=我的位置&destination=latlng:\(self.vm.model.latitude),\(self.vm.model.longitude)|name:\(self.vm.model.activityAddress)&mode=driving&coord_type=gcj02"
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {
                if let url = URL(string: urlStr) {
                    UIApplication.shared.openURL(url)
                }
            } else {
                Toast("该设备未安装百度地图")
            }
        }
        let action1 = UIAlertAction(title: "高德地图", style: .default) { (action) in
            var urlStr = "iosamap://path?sourceApplication=好兔&sid=BGVIS1&did=BGVIS2&dlat=\(self.vm.model.latitude)&dlon=\(self.vm.model.longitude)&dname=\(self.vm.model.activityAddress)&dev=0&t=0"
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
                if let url = URL(string: urlStr) {
                    UIApplication.shared.openURL(url)
                }
            } else {
                Toast("该设备未安装高德地图")
            }
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        HTUtils.share.checkLogin {
            if self.vm.model.isSigned == "1" {
                self.vm.requestCancelMatchSignUp { (success) in
                    NotificationCenter.default.post(name: .HTMatchChanged, object: nil)
                }
            } else {
                self.vm.requestSignupMatch { success in
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .HTMatchChanged, object: nil)
                }
            }
        }
    }
    
    @IBAction func protocolAction(_ sender: UIButton) {
        FYWebViewController.open(HTML_MIANZE)
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        vm.isAgree = sender.isSelected
        if vm.model.status == "1" {
            signupBtn.isEnabled = vm.isAgree
        }
    }
    
    @objc private func timeCutdown() {
        let starDate = Date(vm.model.startTime, formatter: "yyyy-MM-dd HH:mm:ss")
        guard let duration = starDate?.timeIntervalSince(Date()) else {return}
        endTimeLab.text = HTUtils.share.getEndTime(Int(duration))
        if duration <= 0 {
            timer?.invalidate()
            timer = nil
            endTimeLab.text = "报名已结束"
            vm.model.status = "2"
            endTimeDesLab.text = ""
            configCommitStatus()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTActivityPay" {
            let vc = segue.destination as! HTActivityPayViewController
            vc.vm = vm
            vc.isMatch = true
        } else if segue.identifier == "FYMenu" {
            let vc = segue.destination as! FYMenuViewController
            vc.dataArr = ["好兔二维码", "分享连接"]
            vc.popoverPresentationController?.delegate = self
            vc.complete = { text in
                if text == "好兔二维码" {
                    HTShareQrCodeViewController.show(self.vm.model.activityId, type: "3")
                } else if text == "分享连接" {
                    HTAppVM.share.requestShareUrl(self.vm.model.activityId, type: "3") { (model) in
                        self.vm.shareUrl = model.shareUrl
                        let vc = FYShareViewController( model.shareUrl, title: "\(self.vm.model.activityName)", des: "\(self.vm.model.startTime)  \(self.vm.model.activityAddress)", img: UIImage(named: "icon_logo"))
                        vc.isShowGroup = true
                        vc.groupId = self.vm.model.group_id
                        vc.activityId = self.vm.model.activityId
                        vc.type = .match
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTMatchChanged, object: nil)
    }

}

extension HTMatchDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

