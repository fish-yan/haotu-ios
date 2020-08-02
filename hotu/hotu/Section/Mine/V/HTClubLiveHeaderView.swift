//
//  HTClubLiveHeaderView.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/25.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTClubLiveHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var complete: (()->Void)?
    
    var model = HTClubLiveListModel() {
        didSet {
            btn.isSelected = model.isSelected
            titleLab.text = model.activityName
            dateLab.text = model.activityTime
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        model.isSelected = sender.isSelected
        complete?()
    }
    
}
