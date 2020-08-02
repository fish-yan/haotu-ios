//
//  HTNotiListCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/3.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTNotiListCell: UITableViewCell {

    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var statusLab: UILabel!
    var complete: (()->Void)?
        
    var model = HTNoticeModel() {
        didSet {
            contentLab.text = model.content
            timeLab.text = model.createTime
            let isHidden = model.type == "0" || model.status != "0"
            agreeBtn.isHidden = isHidden
            rejectBtn.isHidden = isHidden
            statusLab.isHidden = true
            if model.status == "1" {
                statusLab.isHidden = false
                statusLab.text = "已同意"
            } else if model.status == "2" {
                statusLab.isHidden = false
                statusLab.text = "已拒绝"
            }
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

    @IBAction func agreeAction(_ sender: UIButton) {
        requestVerifyApply(agree: true)
    }
    @IBAction func regectAction(_ sender: UIButton) {
        requestVerifyApply(agree: false)
    }
    
    func requestVerifyApply(agree: Bool) {
        let params = ["operator":(agree ? "1" : "2"), "applyId":model.id]
        FYNetWork.request("broadcast/verifyArchorApply", params: params).responseJSON { (json) in
            self.complete?()
        }
    }
}
