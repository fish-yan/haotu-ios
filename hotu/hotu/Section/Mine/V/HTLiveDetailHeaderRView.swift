//
//  HTLiveDetailHeaderRView.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/25.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveDetailHeaderRView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var imgV1: UIImageView!
    @IBOutlet weak var deleteBtn1: UIButton!
    @IBOutlet weak var favBtn1: UIButton!
    
    @IBOutlet weak var imgV2: UIImageView!
    @IBOutlet weak var deleteBtn2: UIButton!
    @IBOutlet weak var favBtn2: UIButton!
    
    @IBOutlet weak var imgV3: UIImageView!
    @IBOutlet weak var deleteBtn3: UIButton!
    @IBOutlet weak var favBtn3: UIButton!
    
    @IBOutlet weak var imgV4: UIImageView!
    @IBOutlet weak var deleteBtn4: UIButton!
    @IBOutlet weak var favBtn4: UIButton!
    
    var complete: ((Bool)->Void)!
    
    var tapAction: ((Int)->Void)?
    
    var arr = [HTLiveModel]() {
        didSet {
            if arr.count > 0 {
                let model = arr[0]
                imgV1.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
                favBtn1.isSelected = model.isLiked == "1"
                deleteBtn1.isHidden = model.candelete == "0"
            }
            if arr.count > 1 {
                let model = arr[1]
                imgV2.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
                favBtn2.isSelected = model.isLiked == "1"
                deleteBtn2.isHidden = model.candelete == "0"
            }
            if arr.count > 2 {
                let model = arr[2]
                imgV3.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
                favBtn3.isSelected = model.isLiked == "1"
                deleteBtn3.isHidden = model.candelete == "0"
            }
            if arr.count > 3 {
                let model = arr[3]
                imgV4.sd_setImage(with: URL(string: model.thumbnail), completed: nil)
                favBtn4.isSelected = model.isLiked == "1"
                deleteBtn4.isHidden = model.candelete == "0"
            }
        }
    }
    
    
    @IBAction func fav1Action(_ sender: UIButton) {
        if arr.count <= 0 {
            return
        }
        requestFav(arr[0], isSelected: favBtn1.isSelected) { (success) in
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func fav2Action(_ sender: UIButton) {
        if arr.count <= 1 {
            return
        }
        requestFav(arr[1], isSelected: favBtn2.isSelected) { (success) in
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func fav3Action(_ sender: UIButton) {
        if arr.count <= 2 {
            return
        }
        requestFav(arr[2], isSelected: favBtn3.isSelected) { (success) in
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func fav4Action(_ sender: UIButton) {
        if arr.count <= 3 {
            return
        }
        requestFav(arr[3], isSelected: favBtn4.isSelected) { (success) in
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func delete1Action(_ sender: Any) {
        if arr.count <= 0 {
            return
        }
        requestDelete(arr[0], complete: complete)
    }
    
    @IBAction func delete2Action(_ sender: Any) {
        if arr.count <= 1 {
            return
        }
        requestDelete(arr[1],complete: complete)
    }
    
    @IBAction func delete3Action(_ sender: Any) {
        if arr.count <= 2 {
            return
        }
        requestDelete(arr[2],complete: complete)
    }
    
    @IBAction func delete4Action(_ sender: Any) {
        if arr.count <= 3 {
            return
        }
        requestDelete(arr[3],complete: complete)
    }
    
    func requestFav(_ model: HTLiveModel, isSelected: Bool, complete: @escaping(Bool)->Void) {
        let params = ["id": model.id, "type": isSelected ? "0" : "1"]
        FYNetWork.request(LIVE_IMG_FAV, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    func requestDelete(_ model: HTLiveModel, complete: @escaping(Bool)->Void) {
        let params = ["id": model.id]
        FYNetWork.request(LIVE_IMG_DELETE, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        if arr.count > sender.tag {
            tapAction?(sender.tag)
        }
    }
}
