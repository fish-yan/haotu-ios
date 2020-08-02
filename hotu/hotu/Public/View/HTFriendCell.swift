//
//  HTFriendCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/29.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTFriendCell: UITableViewCell {
    @IBOutlet weak var headerImgV: UIImageView!
    
    @IBOutlet weak var vipImgV: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var funsCountLab: UILabel!
    @IBOutlet weak var attentionBtn: UIButton!
    
    var reloadData:(()->Void)?
    
    var attentionAction: ((HTMemberModel)->Void)?
    
    var model = HTMemberModel() {
        didSet {
            headerImgV.sd_setImage(with: URL(string:model.userLogo), completed: nil)
            nameLab.text = model.nick_name
//            accountLab.text = "好兔号:\(model.id)"
            funsCountLab.text = "粉丝:\(model.fansNo)"
            attentionBtn.isHidden = model.user_id == HTUserInfo.share.userId
            switch model.status {
            case "1": // 我关注的
                attentionBtn.isSelected = true
                attentionBtn.setTitle("已关注", for: .selected)
            case "2": // 粉丝
                attentionBtn.isSelected = false
            case "3": // 互相关注
                attentionBtn.isSelected = true
                attentionBtn.setTitle("互相关注", for: .selected)
            case "4": // 未关注
                attentionBtn.isSelected = false
            default:
                break
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
    
    @IBAction func attentionAction(_ sender: UIButton) {
        if let a = attentionAction {
            a(model)
            return
        }
        HTUtils.share.checkLogin {
            self.requestAttention(isAttention: !sender.isSelected)
        }
        
    }
    
    func requestAttention(isAttention: Bool) {
        let api = isAttention ? ATTENTION_USER : CANCEL_ATTENTION
        let params = ["followerUserId": model.user_id]
        FYNetWork.request(api, params: params).responseJSON { (response: HTBaseModel<String>) in
            self.reloadData?()
        }
    }
}
