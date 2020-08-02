//
//  HTBigImgCell.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/21.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTBigImgCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var headerImgV: UIImageView!
    @IBOutlet weak var progressV: UIView!
    @IBOutlet weak var progressW: NSLayoutConstraint!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var bigImgBtn: UIButton!
    private var isScale = false
    private var beginTransform = CGAffineTransform.identity
    
    @IBOutlet weak var titleLab: UILabel!
    
    
    var complete:((UIImage?)->Void)?
    
    var model = HTLiveModel() {
        didSet {
            if let img = SDImageCache.shared.imageFromCache(forKey: model.url) {
                imgV.image = img
                progressV.isHidden = true
                bigImgBtn.isHidden = true
            } else {
                imgV.sd_setImage(with: URL(string: model.thumbnailBigger), completed: nil)
            }
            titleLab.text = model.nickName
            headerImgV.sd_setImage(with: URL(string: model.userLogo), completed: nil)
            favBtn.isSelected = model.isLiked == "1"
            bigImgBtn.setTitle("查看原图\(model.fileSize)", for: .normal)
            addGesture()
        }
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.numberOfTapsRequired = 2
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        longPress.minimumPressDuration = 0.5
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.maximumNumberOfTouches = 1
        imgV.addGestureRecognizer(tap)
        imgV.addGestureRecognizer(pinch)
        imgV.addGestureRecognizer(longPress)
//        imgV.addGestureRecognizer(pan)
        
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        isScale = !isScale
        let scale: CGFloat = isScale ? 2 : 1
        if let tapView = tap.view {
            tapView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    @objc func pinchAction(_ pinch: UIPinchGestureRecognizer) {
        if let pinchView = pinch.view {
            switch pinch.state {
            case .began:
                beginTransform = pinchView.transform
            case .changed:
                var scale = max(pinch.scale * beginTransform.a, 1)
                scale = min(scale, 2)
                var x = max(-(scale * pinchView.bounds.width - SCREEN_WIDTH) / 2, beginTransform.tx)
                x = min((scale * pinchView.bounds.width - SCREEN_WIDTH) / 2, x)
                var y = max(-(scale * pinchView.bounds.height - SCREEN_HEIGHT) / 2, beginTransform.ty)
                y = min((scale * pinchView.bounds.height - SCREEN_HEIGHT) / 2, y)
                pinchView.transform = CGAffineTransform(a: scale, b: beginTransform.b, c: beginTransform.c, d: scale, tx: x, ty: y)
            default: break
            }
        }
    }
    
    @objc func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        if let imgV = longPress.view as? UIImageView,
            let img = imgV.image,
            longPress.state == .began {
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.saveImgComplete(image:error:context:)), nil)
        }
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        if let panView = pan.view {
            
            let point = pan.translation(in: panView)
            switch pan.state {
            case .began:
                beginTransform = panView.transform
            case .changed:
                var x = max(-(beginTransform.a * panView.bounds.width - SCREEN_WIDTH) / 2, point.x * beginTransform.a + beginTransform.tx)
                x = min((beginTransform.a * panView.bounds.width - SCREEN_WIDTH) / 2, x)
                var y = max(-(beginTransform.d * panView.bounds.height - SCREEN_HEIGHT) / 2, point.y * beginTransform.d + beginTransform.ty)
                y = min((beginTransform.d * panView.bounds.height - SCREEN_HEIGHT) / 2, y)
                panView.transform = CGAffineTransform(a: beginTransform.a, b: beginTransform.b, c: beginTransform.c, d: beginTransform.d, tx: x, ty: y)
            default: break
            }
            
        }
    }
    
    @objc func saveImgComplete(image: UIImage, error: Error?, context: UnsafeRawPointer) {
        
    }
    
    @IBAction func favAction(_ sender: UIButton) {
        requestFav { (success) in
            self.favBtn.isSelected = !self.favBtn.isSelected
        }
    }
    
    func requestFav(complete: @escaping(Bool)->Void) {
        let params = ["id": model.id, "type": favBtn.isSelected ? "0" : "1"]
        FYNetWork.request(LIVE_IMG_FAV, params: params).responseJSON { (response: HTBaseModel<String>) in
            complete(true)
        }
    }
    
    @IBAction func bigImgAction(_ sender: UIButton) {
        imgV.sd_setImage(with: URL(string: model.url), placeholderImage: imgV.image, options: .delayPlaceholder, progress: { (p1, p2, url) in
            DispatchQueue.main.async {
                let progress = CGFloat(p1 * 100 / p2)
                sender.setTitle("\(progress)%", for: .normal)
                self.progressW.constant = progress
            }
        }) { (img, e, type, url) in
            sender.isHidden = true
            self.progressV.isHidden = true
        }
    }
}
