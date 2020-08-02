//
//  HTMercCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMercCell: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    
    var type = HTClubDataSourceType.club
    
    var model = HTClubModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.group_logo), completed: nil)
            titleLab.text = model.group_name
            switch type {
            case .club:
                desLab.text = "群主：" + model.ownerName
            case .merc:
                desLab.text = "地址：" + model.address
            default:
                desLab.text = ""
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
