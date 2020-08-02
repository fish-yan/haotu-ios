//
//  HTComentCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCommentCell: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var auLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    
    var parent = ""
    
    var model = HTCommentModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            nameLab.text = model.nickName
            var comment = model.content
            if !model.toUserName.isEmpty && model.toUserId != parent {
                comment = "回复 \(model.toUserName)：\(model.content)"
            }
            contentLab.attributedText = comment.toAttContent()
            dateLab.text = configDate()
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

    private func configDate() -> String {
        var str = ""
        if let date = Date(model.createTime, formatter: "yyyy-MM-dd HH:mm") {
            let ch = Double(Date().toString("HH")) ?? 0
            let duration = Date().timeIntervalSince(date)
            if duration < 120 {
                str = "刚刚"
            } else if duration < 3600 {
                str = "\(Int(duration / 60))分钟前"
            } else if duration < ch * 3600 {
                let h = Int(duration / 3600)
                str = "\(h)小时前"
            } else if duration < (24 + ch) * 3600 {
                str = "昨天\(date.toString("HH:mm"))"
            } else if duration < 4 * 24 * 3600 {
                let d = Int(duration / (3600 * 24))
                str = "\(d)天前"
            } else {
                str = date.toString("MM-dd")
            }
        }
        return str
    }
}
