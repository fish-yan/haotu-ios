//
//  HTActivityDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTActivityDetailViewController: UIViewController {
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerImgV: UIImageView!
    @IBOutlet weak var groubNmLab: UILabel!
    @IBOutlet weak var activityNmLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet var imgVs: [UIImageView]!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var endTimeLab: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var endTimeDesLab: UILabel!
    @IBOutlet weak var adImgV: UIImageView!
    
    @IBOutlet weak var commitV: UIView!
    @IBOutlet weak var updateMatchBtn: UIButton!
    @IBOutlet weak var editView: UIView!
    var vm = HTActivityVM()
    
    var ad: HTItemModel?
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.isHidden = true
        request()
        requestAd()
        NotificationCenter.default.addObserver(self, selector: #selector(request), name: .HTActivityChanged, object: nil)
    }
    
    private func configView() {
        
        bgView.isHidden = false
        headerImgV.sd_setImage(with: URL(string: vm.model.groupLogo), completed: nil)
        groubNmLab.text = vm.model.groupName
        activityNmLab.text = vm.model.activityName
        dateLab.text = vm.model.startTime.formatDate("yyyy-MM-dd HH:mm:ss", to: "yyyy年MM月dd日 HH:mm")
        amountLab.text = vm.model.member_amount + "元/位"
        addressLab.text = vm.model.activityAddress
        countLab.text = vm.model.sign_up_no
        desLab.text = vm.model.remark
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
        
        let maxCount = Int((SCREEN_WIDTH - 74) / 38)
        for (i, imgV) in imgVs.enumerated() {
            if i < vm.model.sign_up_list.count && i < maxCount {
                let m = vm.model.sign_up_list[i]
                imgV.sd_setImage(with: URL(string: m.userLogo), completed: nil)
                let lab = UILabel(frame: CGRect(x: imgV.frame.maxX - 8, y: -10, width: 20, height: 20))
                lab.textColor = .red
                lab.isHidden = m.replace_sign_up_number.toInt() == 0
                lab.text = "+\(m.replace_sign_up_number)"
                lab.font = UIFont.systemFont(ofSize: 10)
                imgV.superview?.addSubview(lab)
            } else {
                imgV.image = UIImage()
            }
        }
        configCommitStatus()
    }
    
    private func configCommitStatus() {
        if vm.model.manager_id == HTUserInfo.share.userId {
            editView.isHidden = vm.model.status != "1"
            updateMatchBtn.isHidden = vm.model.isUpgradeMatch != "1"
        } else {
            editView.isHidden = true
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
            case "5":
                signupBtn.isEnabled = false
                signupBtn.setTitle("活动暂停", for: .disabled)
            case "6":
                signupBtn.isEnabled = false
                signupBtn.setTitle("活动取消", for: .disabled)
            case "8":
                signupBtn.isEnabled = false
                signupBtn.setTitle("活动待退款", for: .disabled)
            default:
                signupBtn.isEnabled = false
                signupBtn.setTitle("活动结束", for: .disabled)
                
            }
        }
        
    }
    
    @objc private func request() {
        vm.requestActivityDetail { (success) in
            self.configView()
        }
    }
    
    func requestAd() {
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_ACTIVITY_DETAIL") { (items) in
            if let item = items?.first {
                self.ad = item
                self.adImgV.sd_setImage(with: URL(string: item.itemName), completed: nil)
                self.adView.isHidden = false
            }
        }
    }

    @IBAction func signUpAction(_ sender: UIButton) {
        HTUtils.share.checkLogin {
            if self.vm.model.isSigned == "1" {
                self.vm.requestCancelActivitySignUp { (success) in
                    NotificationCenter.default.post(name: .HTActivityChanged, object: nil)
                }
            } else {
                self.performSegue(withIdentifier: "HTActivityPay", sender: nil)
            }
        }
    }
    
    @IBAction func telAction(_ sender: UIButton) {
        if let url = URL(string: "tel:\(vm.model.activity_phone_no)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func addressAction(_ sender: UIButton) {
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
    
    @IBAction func protocolAction(_ sender: UIButton) {
        FYWebViewController.open(HTML_MIANZE)
    }
    
    @IBAction func memberListAction(_ sender: UIButton) {
        let vc = HTMemberListViewController()
        vc.title = "报名成员"
        vc.dataSource = vm.model.sign_up_list
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        vm.isAgree = sender.isSelected
        if vm.model.status == "1" {
            signupBtn.isEnabled = vm.isAgree
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        adView.isHidden = true
    }
    
    @IBAction func adTapAction(_ sender: Any) {
        if !ad!.ext.isEmpty {
            HTUtils.share.checkLogin {
                FYWebViewController.open(self.ad!.ext)
            }
        }
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "HTPublishActivityVC") as! HTPublishActivityViewController
        vc.isUpdate = true
        vc.vm.model = vm.model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateMatchAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "HTPublishMatchVC") as! HTPublishMatchViewController
        vc.isUpdate = true
        vc.vm.model = vm.model
        navigationController?.pushViewController(vc, animated: true)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTActivityChanged, object: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTActivityPay" {
            let vc = segue.destination as! HTActivityPayViewController
            vc.vm = vm
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
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    

}
extension HTActivityDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
