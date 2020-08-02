//
//  HTTabBarView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

enum HTTabBarTheme: Int {
    case light, dark
}

class HTTabBarView: UIView {

    @IBOutlet private weak var visView: UIVisualEffectView!
    @IBOutlet weak var mineBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet private weak var homeLine: UIView!
    @IBOutlet private weak var mineLine: UIView!
    
    var btnAction: ((UIButton)->Bool)?
    
    var theme: HTTabBarTheme = .dark {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.configTheme()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        backgroundColor = .clear
        let oneView = UINib(nibName: "HTTabBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        oneView.frame = bounds
        addSubview(oneView)
        btnAction(homeBtn)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        var b = false
        if let ac = btnAction {
            b = ac(sender)
        }
        if !b {return}
        selectedBtn(sender)
    }
    
    func selectedBtn(_ sender: UIButton) {
        if sender != addBtn {
            homeBtn.isSelected = false
            mineBtn.isSelected = false
            sender.isSelected = true
            configLine()
        }
        UIView.animate(withDuration: 0.25) {
            self.configTheme()
        }
    }
    
    private func configLine() {
        homeLine.isHidden = !homeBtn.isSelected
        mineLine.isHidden = !mineBtn.isSelected
        let selectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let unselectedFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        homeBtn.titleLabel?.font = homeBtn.isSelected ? selectedFont : unselectedFont
        mineBtn.titleLabel?.font = mineBtn.isSelected ? selectedFont : unselectedFont
    }
    
    private func configTheme() {
        if theme == .dark {
            homeBtn.setTitleColor(.white, for: .normal)
            homeBtn.setTitleColor(.white, for: .selected)
            mineBtn.setTitleColor(.white, for: .normal)
            mineBtn.setTitleColor(.white, for: .selected)
            homeLine.backgroundColor = .white
            mineLine.backgroundColor = .white
            visView.alpha = 0.3
            backgroundColor = .clear
        } else {
            homeBtn.setTitleColor(.black, for: .normal)
            homeBtn.setTitleColor(.black, for: .selected)
            mineBtn.setTitleColor(.black, for: .normal)
            mineBtn.setTitleColor(.black, for: .selected)
            homeLine.backgroundColor = .black
            mineLine.backgroundColor = .black
            visView.alpha = 0
            backgroundColor = .white
        }
    }
    
}
