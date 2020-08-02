//
//  HTMsgCommentCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/18.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTMsgCommentCell: UITableViewCell {
    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    
    var model = HTCommentModel() {
        didSet {
            headerImg.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            imgV.sd_setImage(with: URL(string: model.faceUrl), completed: nil)
            titleLab.text = model.nickName
            desLab.text = model.content
            dateLab.text = "\(model.operateContent) \(model.timeStr)"
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
