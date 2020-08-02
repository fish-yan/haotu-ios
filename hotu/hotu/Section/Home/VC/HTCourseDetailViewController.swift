//
//  HTCourseDetailViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

class HTCourseDetailViewController: UIViewController {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var tagsLab: YYLabel!
    
    @IBOutlet weak var segment: FYSegment!
    
    @IBOutlet weak var addLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var contentV: UIView!
    
    @IBOutlet weak var startDateLab: UILabel!
    @IBOutlet weak var endDateLab: UILabel!
    @IBOutlet weak var tedianLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var img: UIImageView!
    
    var vm = HTProductVM()
    
    var ad: HTItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.titleArray = ["课程详情","上课地址"]
        segment.selectAction = { index in
            self.contentV.isHidden = index == 1
            self.addView.isHidden = index == 0
        }
        request()
    }
    
    private func configView() {
        imgV.sd_setImage(with: URL(string: vm.productModel.img), completed: nil)
        titleLab.text = vm.productModel.name
        countLab.text = "剩余\(vm.productModel.peopleNumber)个名额"
        tagsLab.attributedText = vm.productModel.tag.toTags(SCREEN_WIDTH - 140)
        priceLab.text = "￥" + vm.productModel.price
        contentLab.text = vm.productModel.remark
        addLab.text = vm.productModel.address
        startDateLab.text = vm.productModel.startTime
        endDateLab.text = vm.productModel.endTime
        tedianLab.text = vm.productModel.properties
    }
    
    private func request() {
        vm.requestProductDetail { (success) in
            self.configView()
        }
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_COURSE_DETAIL") { (items) in
            if let item = items?.first {
                self.ad = item
                self.img.sd_setImage(with: URL(string: item.itemName), completed: nil)
                self.adView.isHidden = false
            }
        }
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: vm.productModel.address, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "百度地图", style: .default) { (action) in
            var urlStr = "baidumap://map/direction?origin=我的位置&destination=latlng:\(self.vm.productModel.latitude),\(self.vm.productModel.longitude)|name:\(self.vm.productModel.address)&mode=driving&coord_type=gcj02"
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
            var urlStr = "iosamap://path?sourceApplication=好兔&sid=BGVIS1&did=BGVIS2&dlat=\(self.vm.productModel.latitude)&dlon=\(self.vm.productModel.longitude)&dname=\(self.vm.productModel.address)&dev=0&t=0"
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
    
    @IBAction func payAction(_ sender: UIButton) {
        if let url = URL(string: "tel:\(vm.productModel.phoneNo)") {
            UIApplication.shared.openURL(url)
        } else {
            Toast("未获取到联系方式")
        }
    }
    @IBAction func adTapAction(_ sender: UIButton) {
        if !ad!.ext.isEmpty {
            HTUtils.share.checkLogin {
                FYWebViewController.open(self.ad!.ext)
            }
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.adView.isHidden = true
    }
    @IBAction func rightItemAction(_ sender: Any) {
        HTShareQrCodeViewController.show(self.vm.productId, type: "4")
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
