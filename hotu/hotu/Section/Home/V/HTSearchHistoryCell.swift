//
//  HTSearchHistoryCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLab: UILabel!
    
    var deleteAction:((String)->Void)?
    
    @IBAction func deleteAction(_ sender: UIButton) {
        if let d = deleteAction {
            d(titleLab.text ?? "")
        }
    }
}
