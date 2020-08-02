//
//  HTLiveDetailCell.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTLiveDetailCell: UICollectionViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    var complete: ((Bool)->Void)!
    
    var model = HTLiveModel() {
        didSet {
            imgV.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
            favBtn.isSelected = model.isLiked == "1"
            deleteBtn.isHidden = model.candelete == "0"
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        requestDelete(complete: complete)
    }
    
    @IBAction func favAction(_ sender: UIButton) {
        requestFav { (success) in
            sender.isSelected = !sender.isSelected
        }
    }
    
    func requestFav(complete: @escaping(Bool)->Void) {
        let params = ["id": model.id, "type": favBtn.isSelected ? "0" : "1"]
        FYNetWork.request(LIVE_IMG_FAV, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    func requestDelete(complete: @escaping(Bool)->Void) {
        let params = ["id": model.id]
        FYNetWork.request(LIVE_IMG_DELETE, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
}
