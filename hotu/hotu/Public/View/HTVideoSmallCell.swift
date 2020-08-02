//
//  HTVideoSmallCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/23.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

enum HTVideoSmallCellType {
    case see, play, like
}

class HTVideoSmallCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var coverImgV: UIImageView!
    @IBOutlet weak var countLab: UILabel!
    
    var type: HTVideoSmallCellType = .like
    
    var model = HTVideoModel() {
        didSet {
            if model.type == "2" {
                if var img = model.imageUrls.first?.url {
                    img = img.replacingOccurrences(of: "\\", with: "")
                    coverImgV.sd_setImage(with: URL(string: img), completed: nil)
                }
            } else {
                if model.coverUrl.isEmpty {
                    coverImgV.sd_setImage(with: URL(string: model.groupLogo), completed: nil)
                } else {
                    coverImgV.sd_setImage(with: URL(string: model.coverUrl), completed: nil)
                }
            }
            switch type {
            case .see:
                typeImg.image = UIImage(named: "icon_video_pause")
                countLab.text = model.seeCount
            case .like:
                let nm = model.isLike == "1" ? "icon_fav_selected" : "icon_fav_unselected"
                typeImg.image = UIImage(named: nm)
                countLab.text = model.likeCount
            case .play:
                typeImg.image = UIImage(named: "icon_video_pause")
                countLab.text = model.seeCount
            }
        }
    }
    
    func setClubLiveModel(_ model: HTClubLiveItemModel) {
        coverImgV.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
        countLab.text = model.likeCount
        let nm = model.isLiked == "1" ? "icon_fav_selected" : "icon_fav_unselected"
        typeImg.image = UIImage(named: nm)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
