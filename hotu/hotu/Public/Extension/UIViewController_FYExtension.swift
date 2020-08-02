//
//  UIViewController_FYExtension.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/25.
//  Copyright © 2019 薛焱. All rights reserved.
//

@objc public protocol BackItemProtocol {
    func navigationShouldPop() -> Bool
}

extension UIViewController: BackItemProtocol {
    public func navigationShouldPop() -> Bool {
        return true
    }
}

extension UIApplication {
    open override var next: UIResponder? {
        UIApplication.once
        return super.next
    }
    private static let once:Void = {
        UIViewController.swizzled()
    }()
}

//MARK: 要求重写了viewWillAppear和viewWillDisappear方法的必须调用父类方法
extension UIViewController {
    
    
    static func swizzled() {
        let originSelArray = [#selector(viewWillAppear(_:)), #selector(viewWillDisappear(_:)), #selector(viewDidLoad), #selector(setNeedsStatusBarAppearanceUpdate)]
        for selector in originSelArray {
            let swzzledSel = "fy_" + selector.description
            if let originMethod = class_getInstanceMethod(self, selector),
                let swzzledMethod = class_getInstanceMethod(self, Selector(swzzledSel)) {
                method_exchangeImplementations(originMethod, swzzledMethod)
            }
        }
    }
    
    @objc func fy_viewWillAppear(_ animated: Bool) {
        if classForCoder.description().hasPrefix("hotu."),
            !(self.parent is HTHomeViewController) { // 排除系统的 VC
            HTUtils.share.vcChanged(self)
            setbackItem()
        }
        fy_viewWillAppear(animated)
    }
    @objc func fy_viewWillDisappear(_ animated: Bool) {
        if classForCoder.description().hasPrefix("hotu.") { // 排除系统的 VC
        }
        fy_viewWillDisappear(animated)
    }
    
    @objc func fy_viewDidLoad() {
        if classForCoder.description().hasPrefix("hotu.") { // 排除系统的 VC
            setbackItem()
        }
        fy_viewDidLoad()
    }
    
    @objc func setbackItem() {
        if navigationItem.leftBarButtonItem != nil {return}
        let backItem = UIBarButtonItem(image: UIImage(named: "icon_prev"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func fy_setNeedsStatusBarAppearanceUpdate() {
        if self != mainVC {
            mainVC?.fy_setNeedsStatusBarAppearanceUpdate()
        }
        fy_setNeedsStatusBarAppearanceUpdate()
    }

    
    @objc private func backAction() {
        if navigationShouldPop() {
            navigationController?.popViewController(animated: true)
        }
    }
    
    var mainVC: HTMainViewController? {
        return tabBarController?.parent as? HTMainViewController
    }
}
