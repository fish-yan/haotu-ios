//
//  HTLaunchAdViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/16.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLaunchAdViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var skipBtn: UIButton!
    
    var ad: HTItemModel?
    
    var timer: Timer?
    
    var duration = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        skipBtn.isHidden = true
        request()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        performSegue(withIdentifier: "HTMainViewController", sender: nil)
    }
    
    func request() {
        HTAppVM.share.requestAd(code: "ADVERTISEMENT_OPNE_PHONE", isLoading: false) { (items) in
            if let item = items?.first {
                self.ad = item
                self.img.sd_setImage(with: URL(string: item.itemName)) { (img, e, t, u) in
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    self.skipBtn.setTitle("跳过\(self.duration)s", for: .normal)
                    self.skipBtn.isHidden = false
                }
            } else {
                self.performSegue(withIdentifier: "HTMainViewController", sender: nil)
            }
        }
    }
    
    @IBAction func adTapAction(_ sender: Any) {
        if let a = self.ad,
            !a.ext.isEmpty {
            performSegue(withIdentifier: "HTMainViewController", sender: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                HTUtils.share.checkLogin {
                    FYWebViewController.open(a.ext)
                }
            }
        }
    }
    
    @objc func timerAction() {
        duration -= 1
        skipBtn.setTitle("跳过\(duration)s", for: .normal)
        if duration <= 0 {
            timer?.invalidate()
            timer = nil
            performSegue(withIdentifier: "HTMainViewController", sender: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
