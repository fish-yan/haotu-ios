//
//  HTClubAcCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/25.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTClubAcCell: UITableViewCell {
    @IBOutlet weak var weekLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    
    var model = HTClubAcItemModel() {
        didSet {
            weekLab.text = model.weekDay
            dateLab.text = model.activityTime
            titleLab.text = model.venueName
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
