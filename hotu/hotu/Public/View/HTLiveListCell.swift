//
//  HTLiveListCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/19.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveListCell: UITableViewCell {
    
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var headerImgV: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var coverImgV: UIImageView!
    var model = HTVideoModel() {
        didSet {
            if model.coverUrl.isEmpty {
                coverImgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
            } else {
                coverImgV.sd_setImage(with: URL(string: model.coverUrl), completed: nil)
            }
            playBtn.isHidden = true
            nameLab.text = model.groupName
            headerImgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
            titleLab.text = model.activityName
            desLab.text = model.remark
            countLab.text = model.content
            statusLab.text = model.statusStr
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let glayer = CAGradientLayer()
        glayer.frame = CGRect(x: 0, y: 80, width: SCREEN_WIDTH - 10, height: 100)
        glayer.startPoint = CGPoint(x: 0, y: 0)
        glayer.endPoint = CGPoint(x:0, y:1)
        glayer.colors = [UIColor(white: 0, alpha: 0.1).cgColor, UIColor.black.cgColor]
        coverImgV.layer.insertSublayer(glayer, at: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        
    }
}
