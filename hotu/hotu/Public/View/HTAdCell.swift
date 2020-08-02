//
//  HTAdCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/15.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTAdCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    
    var closeAction: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        if let c = closeAction {
            c()
        }
    }
}
