//
//  MZDaysCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class FYDaysCell: UICollectionViewCell {
    
    lazy var daysLabel: UILabel = {
        let itemWidth = (SCREEN_WIDTH - 20 * 2 - 10 * 6) / 7.0
        let margin: CGFloat = (itemWidth - 32)/2.0
        let daysLabel = UILabel(frame: CGRect(x: margin, y: margin, width: 32, height: 32))
        daysLabel.textAlignment = .center
        daysLabel.font = UIFont.systemFont(ofSize: 15)
        daysLabel.layer.cornerRadius = 32.0 / 2.0
        daysLabel.layer.masksToBounds = true
        daysLabel.layer.shouldRasterize = true
        return daysLabel
    }()
    
    var hasPoint: Bool = false {
        didSet {
            if hasPoint {
                self.daysLabel.layer.addSublayer(self.pointLayer)
            } else {
                pointLayer.removeFromSuperlayer()
            }
        }
    }
    
    var isSelectedItem: Bool = false {
        didSet {
            if isSelectedItem {
                self.daysLabel.textColor = UIColor(hex: 0xFA375C)
            } else {
                daysLabel.textColor = UIColor(hex: 0x4B4B4B)
            }
        }
    }
    
    //是否禁用
    var isDisable: Bool = false {
        didSet {
            if isDisable {
                self.daysLabel.textColor = UIColor(hex:0x9D9D9D)
            }
        }
    }
    
    //清除现有日期label上的所有样式
    func clearDaysLabelStyle() {
        daysLabel.text = ""
        daysLabel.backgroundColor = UIColor.white
        daysLabel.textColor = UIColor(hex:0x4B4B4B)
        pointLayer.removeFromSuperlayer()
    }
    
    private lazy var pointLayer: CALayer = {
        let point = CALayer()
        point.backgroundColor = UIColor(hex:0xFFA700).cgColor
        var originX: CGFloat = (self.daysLabel.frame.width - 6) / 2.0
        point.frame = CGRect(x: originX, y: self.daysLabel.frame.height - 6, width: 6, height: 6)
        point.cornerRadius = point.bounds.width / 2
        point.masksToBounds = true
        return point
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(daysLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
