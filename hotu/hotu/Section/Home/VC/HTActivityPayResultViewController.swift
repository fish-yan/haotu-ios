//
//  HTActivityPayResultViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/21.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTActivityPayResultViewController: UIViewController {
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adImg: UIImageView!
    
    var ad: HTItemModel?
    
    var isMatch = false
        
    var vm = HTActivityVM()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLab.text = vm.model.totalPrice + "元"
        requestAd()
    }
    
    func requestAd() {
        var key = "ADVERTISEMENT_ACTIVITY_PAY_SUCCESS"
        if isMatch {
            key = "ADVERTISEMENT_MATCH_PAY_SECCESS"
        }
        HTAppVM.share.requestAd(code: key) { (items) in
            if let item = items?.first {
                self.ad = item
                self.adImg.sd_setImage(with: URL(string: item.itemName), completed: nil)
                self.adView.isHidden = false
            }
        }
    }
    
    @IBAction func completeAction(_ sender: Any) {
        if noteBtn.isSelected {
            vm.requestSetNote { (success) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func billAction(_ sender: Any) {
        if noteBtn.isSelected {
            vm.requestSetNote { (success) in
                if let vc = self.navigationController?.viewControllers.filter({$0 is HTActivityDetailViewController || $0 is HTMatchDetailViewController}).first {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        } else {
            if let vc = navigationController?.viewControllers.filter({$0 is HTActivityDetailViewController || $0 is HTMatchDetailViewController}).first {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let vc = FYShareViewController(vm.shareUrl, title: "\(vm.model.activityName)", des: "\(vm.model.startTime)  \(vm.model.activityAddress)", img: UIImage(named: "icon_logo"))
        vc.isShowGroup = true
        vc.groupId = vm.model.group_id
        vc.activityId = vm.model.activityId
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func dateAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func adTapAction(_ sender: Any) {
        if !ad!.ext.isEmpty {
            let url = ad!.ext + "?adId=\(ad!.itemCode)"
            FYWebViewController.open(url)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.adView.isHidden = true
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
