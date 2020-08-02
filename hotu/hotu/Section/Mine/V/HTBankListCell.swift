//
//  HTBankListCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTBankListCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var typeLab: UILabel!
    
    @IBOutlet weak var cardNumLab: UILabel!
    
    var model = HTBankModel() {
        didSet{
            imgV.sd_setImage(with: URL(string: model.bank_logo), completed: nil)
            nameLab.text = model.bank_name
            cardNumLab.text = model.bank_account
            typeLab.text = "储蓄卡"
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
