//
//  HTCutdownBtn.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCutdownBtn: UIButton {
    
    private var duration = 60
    
    private var timer: Timer?
    
    private var defaultBgColor: UIColor?

    func cutDown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        isEnabled = false
        setTitle("\(duration)s后重试", for: .disabled)
        setTitleColor(UIColor.lightGray, for: .disabled)
        defaultBgColor = backgroundColor
        backgroundColor = UIColor(hex: 0xF0F0F0)
        
    }
    
    @objc private func timerAction() {
        duration -= 1
        if duration <= 0 {
            isEnabled = true
            backgroundColor = defaultBgColor
            timer?.invalidate()
            timer = nil
            return
        }
        setTitle("\(duration)s后重试", for: .disabled)
    }

}
