//
//  FYDatePicker.swift
//  Crabs_star
//
//  Created by FishYan on 2018/2/8.
//  Copyright © 2018年 com.newlandcomputer.app. All rights reserved.
//

import UIKit

class FYDatePicker: UIView {
        
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
    var complete: ((_ date: Date)->Void)!
    
//    var datePickerMode: UIDatePicker.m
    
    private var oneView: UIView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        oneView = UINib(nibName: "FYDatePicker", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        oneView.addGestureRecognizer(tap)
        alpha = 0
        addSubview(oneView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        oneView.frame = bounds
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        FYDatePicker.hidenDatePicker()
    }
    @IBAction func commitBtnAction(_ sender: UIButton) {
        FYDatePicker.hidenDatePicker()
        complete(datePicker.date)
    }
    
    @discardableResult
    static func showDatePicker(complete: @escaping (_ date: Date)->Void) -> FYDatePicker {
        hidenDatePicker()
        let datePickerView = FYDatePicker(frame: UIScreen.main.bounds)
        datePickerView.complete = complete
        datePickerView.datePicker.date = Date()
        datePickerView.tag = -1111
        UIApplication.shared.keyWindow?.addSubview(datePickerView)
        CATransaction.setCompletionBlock {
            datePickerView.bottomMargin.constant = 0
            UIView.animate(withDuration: 0.3) {
                datePickerView.alpha = 1
                datePickerView.layoutIfNeeded()
            }
        }
        return datePickerView
    }
    
    static func hidenDatePicker() {
        guard let datePickerView = UIApplication.shared.keyWindow?.viewWithTag(-1111) as? FYDatePicker else {return}
        datePickerView.bottomMargin.constant = -287
        UIView.animate(withDuration: 0.3, animations: {
            datePickerView.alpha = 0
            datePickerView.layoutIfNeeded()
        }) { (success) in
            datePickerView.removeFromSuperview()
        }
    }
    
    @objc func tapAction() {
        FYDatePicker.hidenDatePicker()
    }
}
