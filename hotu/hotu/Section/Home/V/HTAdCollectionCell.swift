//
//  HTAdCollectionCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/16.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTAdCollectionCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    
    var closeAction: (()->Void)?
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        if let c = closeAction {
            c()
        }
    }
    
}
