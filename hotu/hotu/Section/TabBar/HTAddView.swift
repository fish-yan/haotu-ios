//
//  HTAddView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTAddView: UIView {
    
    var isShow = false
    
    var btnAction: ((Int) -> Void)?
    
    var addBtn: UIButton?
    
    private var oneView: UIView!
    
    
    @IBOutlet weak var productLine: UIView!
    @IBOutlet weak var courseLine: UIView!
    @IBOutlet weak var activityLine: UIView!
    @IBOutlet weak var matchLine: UIView!
    @IBOutlet weak var matchBtn: UIButton!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var courseBtn: UIButton!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var liveBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        oneView = UINib(nibName: "HTAddView", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        oneView.frame = bounds
        addSubview(oneView)
        /*
        switch HTUserInfo.share.role {
        case .visitor, .normal:
            matchBtn.isHidden = true
            activityBtn.isHidden = true
            productBtn.isHidden = true
            courseBtn.isHidden = true
            matchLine.isHidden = true
            activityLine.isHidden = true
            productLine.isHidden = true
            courseLine.isHidden = true
            liveBtn.isHidden = true
        case .anchor:
            matchBtn.isHidden = true
            activityBtn.isHidden = true
            productBtn.isHidden = true
            courseBtn.isHidden = true
            matchLine.isHidden = true
            activityLine.isHidden = true
            productLine.isHidden = true
            courseLine.isHidden = true
        case .coach:
            matchBtn.isHidden = true
            activityBtn.isHidden = true
            productBtn.isHidden = true
            matchLine.isHidden = true
            activityLine.isHidden = true
            productLine.isHidden = true
        case .merc:
            matchBtn.isHidden = true
            activityBtn.isHidden = true
            courseBtn.isHidden = true
            matchLine.isHidden = true
            activityLine.isHidden = true
            courseLine.isHidden = true
        case .club:
            productBtn.isHidden = true
            courseBtn.isHidden = true
            productLine.isHidden = true
            courseLine.isHidden = true
            matchBtn.isHidden = true
            matchLine.isHidden = true
        case .all:
            break
        }
 */
    }
    
    func show(on view: UIView) {
        view.addSubview(self)
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        isShow = true
        addBtn?.isSelected = true
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
        isShow = false
        addBtn?.isSelected = false
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        dismiss()
        if let b = btnAction {
            b(sender.tag)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == oneView {
            dismiss()
        }
    }
    
}
