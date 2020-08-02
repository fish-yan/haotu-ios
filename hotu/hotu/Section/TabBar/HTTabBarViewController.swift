//
//  HTTabBarViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTTabBarViewController: UITabBarController {
    
    var htTabBar: HTTabBarView!
    
    private var addView: HTAddView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabbarFrame()
        HTAppVM.share.checkUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTabbarFrame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabbarFrame()
    }
    
    private func setTabbarFrame() {
//        var height: CGFloat = 64
//        if UIApplication.shared.statusBarFrame.height == 20 {
//            height = 64
//        } else {
//            height = 98
//        }
//        tabBar.frame = CGRect(x: 0, y: SCREEN_HEIGHT - height, width: SCREEN_WIDTH, height: height)
        for subV in tabBar.subviews {
            subV.isUserInteractionEnabled = subV == htTabBar ? true : false
        }
        htTabBar.frame = tabBar.bounds
        tabBar.bringSubviewToFront(htTabBar)
    }
    
    func configureTabBar() {
        tabBar.backgroundImage = UIImage(named: "clear")
        htTabBar = HTTabBarView(frame: tabBar.bounds)
        tabBar.addSubview(htTabBar)
        htTabBar.btnAction = { [weak self] (btn) in
            switch btn.tag {
            case -1:
                HTUtils.share.checkLogin {
                    self?.configAddView(btn)
                }
            case 0:
                self?.resetAddView()
                self?.selectedIndex = btn.tag
            case 1:
                HTUtils.share.checkLogin {
                    self?.htTabBar.selectedBtn(btn)
                    self?.resetAddView()
                    self?.selectedIndex = btn.tag
                }
                return false
            default: break
            }
            return true
        }
    }
    
    private func configAddView(_ btn: UIButton) {
        if self.addView?.isShow ?? false {
            self.addView?.dismiss()
            self.addView = nil
        } else {
            self.addView = HTAddView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.tabBar.frame.height))
            self.addView?.addBtn = btn
            self.addView?.show(on: self.view)
            self.addView?.btnAction = { index in
                switch index {
                case 0, 1: // 视频图片
                    self.performSegue(withIdentifier: "HTPublish", sender: index)
                case 2: // 赛事
                    HTUtils.share.checkVitified {
                        self.performSegue(withIdentifier: "HTPublishMatch", sender: nil)
                    }
                case 3: // 活动
                    HTUtils.share.checkVitified {
                        self.performSegue(withIdentifier: "HTPublishActivity", sender: nil)
                    }
                case 4: // 课程
                    HTUtils.share.checkVitified {
                        self.performSegue(withIdentifier: "HTPublishCourse", sender: nil)
                    }
                case 5: // 商品
                    HTUtils.share.checkVitified {
                        self.performSegue(withIdentifier: "HTPublishProduct", sender: nil)
                    }
                case 6: // 直播
                    self.performSegue(withIdentifier: "HTLiveACViewController", sender: nil)
                default:
                    break
                }
            }
        }
    }
    
    private func resetAddView() {
        self.addView?.dismiss()
        self.addView = nil
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTPublish" {
            let nvc = segue.destination as! UINavigationController
            if let vc = nvc.viewControllers.first as? HTPublishViewController,
                let index = sender as? Int {
                vc.vm.type = index == 0 ? .video : .image
            }
        }
    }

}
