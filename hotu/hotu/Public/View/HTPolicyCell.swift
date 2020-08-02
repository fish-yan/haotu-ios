//
//  HTPolicyCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPolicyCell: UITableViewCell {
    @IBOutlet weak var desLab: UILabel!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var fromLab: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var logoImgV: UIImageView!
    
    var model = HTPolicyModel() {
        didSet {
            // FIXME: 参数未知
            titleLab.text = model.safeTitle
            desLab.text = "期限:" + "\(model.startDate)-\(model.endDate)"
            fromLab.text = "来自:" + model.groupName
            logoImgV.sd_setImage(with: URL(string: model.safeCompanyLogo), completed: nil)
            switch model.status {
            case "1":
                statusLab.text = "保险未开始"
            case "2":
                statusLab.text = "保障中"
            case "3":
                statusLab.text = "保障结束"
            default:
                break
            }
            
            imgV.sd_setImage(with: URL(string: model.safeUrl), completed: nil)
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
