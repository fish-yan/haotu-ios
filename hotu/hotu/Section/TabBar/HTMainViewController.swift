//
//  HTMainViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import Flutter

class HTMainViewController: UIViewController {
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var courseBtn: UIButton!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var clubBtn: UIButton!
    
    @IBOutlet weak var guideScrollView: UIScrollView!

    var standKey = "guide"
    
    var currentVC: UIViewController?
    
    var guidComplete:(()->Void)?
    
    var isShow: Bool {
        get {
            return scrollView.contentOffset.x != 220
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topMargin.constant = UIApplication.shared.statusBarFrame.height + 44
        HTUtils.share.viewControllerChanged = { vc in
            self.currentVC = vc
            self.setNeedsStatusBarAppearanceUpdate()
        }
        configView()
//        configGuideView()
        roleChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(roleChanged(_:)), name: .HTRoleChanged, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(roleChanged(_:)), name: .HTUserInfoChanged, object: nil)
    }
    
    func configView() {
        activityBtn.isHidden = true
        courseBtn.isHidden = true
        productBtn.isHidden = true
        clubBtn.isHidden = true
        applyBtn.isHidden = true
        switch HTUserInfo.share.role {
        case .visitor, .normal, .anchor:break
//            applyBtn.isHidden = false
        case .coach:
//            clubBtn.isHidden = false
            courseBtn.isHidden = false
        case .merc:
//            clubBtn.isHidden = false
            productBtn.isHidden = false
        case .club:
//            clubBtn.isHidden = false
            activityBtn.isHidden = false
        case .all:
            activityBtn.isHidden = false
            courseBtn.isHidden = false
            productBtn.isHidden = false
//            clubBtn.isHidden = false
//            applyBtn.isHidden = false
        }
    }
    
    func configGuideView() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            standKey = version
        }
        let isLoaded = UserDefaults.standard.bool(forKey: standKey)
        if !isLoaded {
            guideScrollView.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentOffset = CGPoint(x: 220, y: 0)
    }
    
    @IBAction func myActivityAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTMyActivity", sender: nil)
    }
    
    @IBAction func myProductAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTMyProduct", sender: nil)
    }
    
    @IBAction func myCourseAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTMyCrouse", sender: nil)
    }
    
    @IBAction func walletAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTWallet", sender: nil)
    }
    
    @IBAction func myClubAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTMyClub", sender: nil)
    }
    
    @IBAction func applyAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTApply", sender: nil)
    }
    
    @IBAction func myPolicyAction(_ sender: UIButton) {
        hiddenSetView()
        visibleViewController?.performSegue(withIdentifier: "HTMyPolicy", sender: nil)
    }
    
    @IBAction func userProtocolAction(_ sender: UIButton) {
        hiddenSetView()
        FYWebViewController.open(HTML_USER_PRO)
    }
    
    @IBAction func setAction(_ sender: UIButton) {
        hiddenSetView()
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterVC = FYFlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterVC.hidesBottomBarWhenPushed = true
        visibleViewController?.navigationController?.pushViewController(flutterVC, animated: true)
//        visibleViewController?.performSegue(withIdentifier: "HTSet", sender: nil)
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        hiddenSetView()
    }
    
    func showSetView() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        maskView.isHidden = false
    }
    
    func hiddenSetView() {
        scrollView.setContentOffset(CGPoint(x: 220, y: 0), animated: true)
        maskView.isHidden = true
    }
    
    @objc private func roleChanged(_ notification: Notification? = nil) {
        if let objc = notification?.object as? [String: Any],
            let role = objc[HTNotificationKey.role] as? HTRoleType,
            (role != .visitor && role != .all) {
            HTAppVM.share.requestUserInfo { (success) in
                self.configView()
            }
        } else {
            configView()
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == maskView {
            hiddenSetView()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = currentVC,
            !(vc is HTMainViewController) {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .HTRoleChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .HTUserInfoChanged, object: nil)
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

extension HTMainViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView {
            if !decelerate {
                if scrollView.contentOffset.x >= 110 {
                    hiddenSetView()
                } else {
                    showSetView()
                }
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.x >= 110 {
                hiddenSetView()
            } else {
                showSetView()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == guideScrollView {
            var alpha = (SCREEN_WIDTH * 2 - guideScrollView.contentOffset.x) / (SCREEN_WIDTH * 1)
            alpha = Swift.max(0, alpha)
            alpha = Swift.min(1, alpha)
            guideScrollView.alpha = alpha
            if scrollView.contentOffset.x > SCREEN_WIDTH * 1.9 {
                self.guideScrollView.isHidden = true
                UserDefaults.standard.set(true, forKey: standKey)
                if let c = guidComplete {
                    c()
                }
            }
        }
    }
}

