
//
//  FYSegment.swift
//  Crabs_star
//
//  Created by FishYan on 2017/12/20.
//  Copyright © 2017年 com.newlandcomputer.app. All rights reserved.
//

import UIKit

class FYSegment: UIView {
    
    @IBInspectable var defautColor: UIColor = UIColor(hex: 0x212121) {
        didSet{
            setSelectedColor()
        }
    }
    
    @IBInspectable var selectedColor: UIColor = UIColor(hex: 0x00baff) {
        didSet{
            setSelectedColor()
        }
    }
    
    @IBInspectable var bottomLineColor: UIColor = UIColor(hex: 0xE1E1E1) {
        didSet{
            bottomLine.backgroundColor = bottomLineColor
        }
    }
    
    @IBInspectable var selectFontSize: CGFloat = 16 {
        didSet{
            setSelectedColor()
        }
    }
    
    @IBInspectable var defaultFontSize: CGFloat = 15 {
        didSet{
            setSelectedColor()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 0
    
    var titleArray = ["Title"] {
        didSet {
            for v in btnArray {
                v.removeFromSuperview()
            }
            btnArray = [UIButton]()
            for (index, title) in titleArray.enumerated() {
                let btn = UIButton(type: .custom)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitle(title, for: UIControl.State())
                btn.setTitleColor(defautColor, for: UIControl.State())
                btn.addTarget(self, action: #selector(btnAction(_:)), for:.touchUpInside)
                let tag = UIView()
                tag.backgroundColor = .systemRed
                tag.layer.cornerRadius = 3
                tag.tag = -100
                tag.isHidden = true
                btn.addSubview(tag)
                if index == 0 {
                    btn.setTitleColor(selectedColor, for: UIControl.State())
                }
                btnArray.append(btn)
                addSubview(btn)
            }
            setSelected(0)
        }
    }
    
    var selectedIndex = 0 {
        didSet {
            setSelectedColor()
            UIView.animate(withDuration: 0.2) {
                self.selectedLine.frame = CGRect(x: self.btnWidth * CGFloat(self.selectedIndex) + (self.btnWidth - self.lineWidth)/2, y: self.frame.height - 2, width: self.lineWidth, height: 2)
            }
        }
    }
    
    var process: CGFloat = 0.0 {
        didSet{
            self.selectedLine.frame = CGRect(x: process * bounds.width + (btnWidth - lineWidth)/2, y: self.frame.height - 2, width: self.lineWidth, height: 2)
            
            let index = (titleArray.count * Int(process * 10000))
            if index % 10000 == 0 && index / 10000 != selectedIndex {
                setSelected(index / 10000)
            }
        }
    }
    
    var selectAction: ((_ index: Int) -> Void)?
    
    private var bottomLine = UIView()
    
    var btnArray = [UIButton]()
    
    private var btnWidth = CGFloat(0)
    
    private var selectedLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        btnWidth = frame.width / CGFloat(titleArray.count)
        lineWidth = lineWidth <= 0 ? btnWidth : lineWidth
        selectedLine.frame = CGRect(x: self.btnWidth * CGFloat(self.selectedIndex) + (self.btnWidth - self.lineWidth)/2, y: self.frame.height - 2, width: self.lineWidth, height: 2)
//        selectedLine.frame = CGRect(x: (btnWidth - lineWidth)/2, y: frame.height - 2, width: lineWidth, height: 2)
        
        for (index, btn) in btnArray.enumerated() {
            btn.frame = CGRect(x: CGFloat(index) * btnWidth, y: 0, width: btnWidth, height: frame.height - 1)
            if let tag = btn.viewWithTag(-100) {
                tag.frame = CGRect(x: self.btnWidth - 10, y: 10, width: 6, height: 6)
            }
        }
    }
    
    private func loadView() {
        bottomLine.backgroundColor = UIColor(hex: 0xE1E1E1)
        addSubview(bottomLine)
        
        selectedLine.backgroundColor = selectedColor
        addSubview(selectedLine)
    }
    
    @objc private func btnAction(_ btn: UIButton) {
        setSelected(btnArray.firstIndex(of: btn) ?? 0)
    }
    
    private func setSelectedColor() {
        selectedLine.backgroundColor = selectedColor
        for (index, element) in btnArray.enumerated() {
            if index == selectedIndex {
                element.setTitleColor(selectedColor, for: UIControl.State())
                element.titleLabel?.font = UIFont.systemFont(ofSize: selectFontSize, weight: .semibold)
            } else {
                element.setTitleColor(defautColor, for: UIControl.State())
                element.titleLabel?.font = UIFont.systemFont(ofSize: defaultFontSize, weight: .regular)
            }
        }
    }
    
    public func setSelected(_ index: Int) {
        selectedIndex = index
        if let selectAction = selectAction {
            selectAction(selectedIndex)
        }
    }
    
    public func showTag(on index: Int, isHidden: Bool) {
        let btn = btnArray[index]
        if let tag = btn.viewWithTag(-100) {
            tag.isHidden = isHidden
        }
    }
    
    public func isTagHidden(on index: Int) -> Bool {
        let btn = btnArray[index]
        if let tag = btn.viewWithTag(-100) {
            return tag.isHidden
        } else {
            return true
        }
    }
}
