//
//  FYNumView.swift
//  joint-operation
//
//  Created by Yan on 2018/12/9.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit

class FYNumView: UIView {
    

    @IBOutlet private weak var numTF: UITextField!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var numChanged: ((String) -> Void)?
    
    private var min: Double = 0.0
    
    private var max: Double = 10000
    
    private var space: Double = 1
    
    private var oneView: UIView!
    
    var num: Double = 0.0 {
        didSet {
            configureNumTF()
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
        oneView = UINib(nibName: "FYNumView", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        oneView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        addSubview(oneView)
        configureNumTF()
    }
    
    func set(_ num: Double = 0.0, min: Double = 0.0, max: Double = 10000.0, space: Double = 1) {
        self.min = min
        self.max = max
        self.space = space
        self.num = num
    }
    
    
    func configureNumTF() {
        var tempNum = Swift.max(num, min)
        tempNum = Swift.min(tempNum, max)
        tempNum = doubleFormatter(tempNum)
        minusBtn.isEnabled = tempNum > min
        addBtn.isEnabled = tempNum < max
        if space == 1 {
            numTF.text = String(Int(tempNum)).removeLastZero()
        } else {
            numTF.text = String(tempNum)
        }
        if let numChanged = self.numChanged,
            Double(numTF.text!) != num {
            numChanged(numTF.text ?? "0")
        }
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if let text = sender.text,
            var n = Double(text) {
            if n < min {
                n = min
                Toast("最小值不能小于\(doubleFormatter(min))")
            }
            if n > max {
                n = max
                Toast("最大值不能大于\(doubleFormatter(max))")
            }
            num = n
            if let numChanged = self.numChanged {
                numChanged(numTF.text ?? "0")
            }
        } else {
            Toast("输入有误")
            configureNumTF()
        }
    }
    
    @IBAction func minusBtnAction(_ sender: UIButton) {
        num -= space
        if let numChanged = self.numChanged {
            numChanged(numTF.text ?? "0")
        }
    }
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        num += space
        if let numChanged = self.numChanged {
            numChanged(numTF.text ?? "0")
        }
    }

}
