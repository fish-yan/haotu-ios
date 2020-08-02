//
//  HTProductCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

class HTProductCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var tagLab: YYLabel!
    
    var model = HTProductModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.img), completed: nil)
            titleLab.text = model.name
            desLab.text = model.properties
            priceLab.text = "￥" + model.price
            tagLab.attributedText = model.tag.toTags(SCREEN_WIDTH - 151)
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
