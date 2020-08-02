//
//  HTSearchHeaderView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var segment: FYSegment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segment.titleArray = ["大家在搜"]
    }
    
}
