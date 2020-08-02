//
//  HTBillCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/22.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTBillCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    var model = HTBillModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.logo), completed: nil)
            titleLab.text = model.group_name
            if model.type == "1" {
                amountLab.text = "+\(model.amount)"
                amountLab.textColor = .green
            } else {
                amountLab.text = "-\(model.amount)"
                amountLab.textColor = .red
            }
            dateLab.text = model.create_time
            if model.source == "1" {
                typeLab.text = "来源：微信支付"
            } else if model.source == "4" {
                typeLab.text = "来源：余额支付"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
