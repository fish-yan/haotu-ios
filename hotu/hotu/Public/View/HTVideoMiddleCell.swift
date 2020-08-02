//
//  HTVideoMiddleCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoMiddleCell: UICollectionViewCell {
    @IBOutlet weak var headerImgV: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var coverImgV: UIImageView!
    @IBOutlet weak var favImgV: UIImageView!
    
    @IBOutlet weak var favCountLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    var model = HTVideoModel() {
        didSet {
            headerImgV.sd_setImage(with: URL(string: model.userImageUrl), completed: nil)
            nameLab.text = model.userNickName
            if model.type == "1" {
                coverImgV.sd_setImage(with: URL(string: model.coverUrl), completed: nil)
            } else {
                if let img = model.imageUrls.first?.url {
                    coverImgV.sd_setImage(with: URL(string: img), completed: nil)
                }
            }
            
            let imgNm = model.isLike == "1" ? "icon_fav_selected" : "icon_fav_unselected"
            favImgV.image = UIImage(named: imgNm)
            favCountLab.text = model.likeCount
            contentLab.text = model.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
