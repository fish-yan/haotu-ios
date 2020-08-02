//
//  HTSearchHotCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchHotCell: UICollectionViewCell {
    @IBOutlet weak var typeLab: UILabel!
    
    @IBOutlet weak var titleLab: UILabel!
    
    var model = HTSearchKeyModel() {
        didSet {
            titleLab.text = model.keyword
            typeLab.isHidden = false
            switch model.type {
            case "1":
                typeLab.text = "新"
            case "2":
                typeLab.text = "热"
            case "3":
                typeLab.text = "爆"
            default:
                typeLab.isHidden = true
                typeLab.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
