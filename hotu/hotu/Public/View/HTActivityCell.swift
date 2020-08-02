//
//  HTActivityCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTActivityCell: UITableViewCell {
    
    @IBOutlet private weak var titleLab: UILabel!
    @IBOutlet private weak var matchLab: UILabel!
    @IBOutlet private weak var imgV: UIImageView!
    @IBOutlet private weak var timeLab: UILabel!
    @IBOutlet private weak var addressLab: UILabel!
    @IBOutlet private weak var photosV: UIView!
    @IBOutlet private weak var distanceLab: UILabel!
    @IBOutlet private var photosImgV: [UIImageView]!
    @IBOutlet private weak var countLab: UILabel!
    @IBOutlet weak var endV: UIImageView!
    @IBOutlet weak var liveImgV: UIImageView!
    
    var type = 0
    
    var model = HTActivityModel() {
        didSet {
            titleLab.text = model.activityName
            imgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
            timeLab.text = "时间:\(model.startTime.formatDate())"
            addressLab.text = "地点:\(model.activityAddress)"
            distanceLab.text = model.distance
            countLab.text = "\(model.sign_up_no)人报名"
            photosV.isHidden = model.isPk != "0" || model.sign_up_list.isEmpty
            matchLab.isHidden = model.isPk != "2"
            liveImgV.isHidden = model.stage != "2"
            var imgNm = ""
            if type == 0 {
                if ["3", "5", "6", "8"].contains(model.status) {
                    imgNm = "icon_status_end"
                }
            } else {
                imgNm = model.isSelected ? "icon_selected" : "icon_unselected"
            }
            endV.image = UIImage(named: imgNm)

            let maxCount = Int((SCREEN_WIDTH - 96) / 38)
            for (i, imgV) in photosImgV.enumerated() {
                if i < model.sign_up_list.count && i < maxCount {
                    let url = model.sign_up_list[i].userLogo
                    imgV.sd_setImage(with: URL(string: url), completed: nil)
                } else {
                    imgV.image = UIImage()
                }
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
