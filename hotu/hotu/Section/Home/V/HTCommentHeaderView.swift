//
//  HTCommentHeaderView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCommentHeaderView: UIView {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    @IBOutlet weak var auLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    
    var btnAction:((UIButton)->Void)?
    
    var model = HTCommentModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            nameLab.text = model.nickName
            contentLab.attributedText = model.content.toAttContent()
            dateLab.text = configDate()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let oneView = UINib(nibName: "HTCommentHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        oneView.frame = bounds
        addSubview(oneView)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        if let ba = btnAction {
            ba(sender)
        }
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
