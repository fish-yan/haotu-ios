//
//  HTVideoImageCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/3.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTVideoImageCell: UICollectionViewCell {
    
    var imgUrl = "" {
        didSet {
            imageV.sd_setImage(with: URL(string: imgUrl), completed: nil)
        }
    }
    
    private var imageV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageV = UIImageView(frame: bounds)
        imageV.contentMode = .scaleAspectFit
        contentView.addSubview(imageV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
