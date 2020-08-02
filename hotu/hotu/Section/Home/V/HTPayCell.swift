//
//  HTPayCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/11.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPayCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    
    @IBOutlet weak var numView: FYNumView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
