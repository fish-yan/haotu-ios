//
//  HTActivtyListCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/23.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTActivtyListCell: UITableViewCell {

    
    @IBOutlet weak var topV: UIStackView!
    @IBOutlet private weak var titleLab: UILabel!
    @IBOutlet private weak var imgV: UIImageView!
    @IBOutlet private weak var timeLab: UILabel!
    @IBOutlet private weak var photosV: UIView!
    @IBOutlet private weak var distanceLab: UILabel!
    @IBOutlet private weak var countLab: UILabel!
    @IBOutlet private weak var orgNmLab: UILabel!
    @IBOutlet weak var isSignLab: UILabel!
    @IBOutlet weak var remarkLab: UILabel!
    
    @IBOutlet weak var remarkV: UIView!
    @IBOutlet weak var groupNmLab: UILabel!
    
    @IBOutlet weak var addLab: UILabel!
    @IBOutlet weak var groupImgV: UIImageView!
    @IBOutlet weak var headerIconsV: HTHeadIconListView!
    var type = 0
    
    var model = HTActivityModel() {
        didSet {
            groupImgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
            groupNmLab.text = model.groupName
            titleLab.text = model.venueName
            if model.venueName.isEmpty {
                titleLab.text = model.activityName
            }
            imgV.sd_setImage(with: URL(string: model.headIcon), completed: nil)
            if model.headIcon.isEmpty {
                imgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
            }
            addLab.text = model.activityAddress
            addLab.isHidden = model.activityAddress.isEmpty
            timeLab.text = model.startTime
            timeLab.font = UIFont(name: "Digital-7 Mono", size: 28)
            distanceLab.text = model.distance
            countLab.text = "\(model.sign_up_no)人报名"
            photosV.isHidden = model.isPk != "0" || model.sign_up_list.isEmpty
            orgNmLab.text = "组织者 \(model.owner_name)"
            isSignLab.isHidden = model.isSignUp == "0"
            remarkLab.text = model.remark
            remarkV.isHidden = model.remark.isEmpty
            headerIconsV.list = model.sign_up_list
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
