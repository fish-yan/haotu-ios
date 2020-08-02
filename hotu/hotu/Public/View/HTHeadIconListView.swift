//
//  HTHeadIconListView.swift
//  hotu
//
//  Created by 薛焱 on 2020/5/27.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTHeadIconListView: UIView {
    
    @IBOutlet var photosImgV: [UIImageView]!
    
    var list = [HTMemberModel]() {
        didSet {
            setHeaders()
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
    
    func loadView() {
    let v = UINib(nibName: "HTHeadIconListView", bundle: nil).instantiate(withOwner: self, options: nil).last as! UIView
        v.frame = bounds
        addSubview(v)
    }
    
    func setHeaders() {
        let maxCount = Int((bounds.width) / 38)
        for (i, imgV) in photosImgV.enumerated() {
            if i < list.count && i < maxCount {
                let m = list[i]
                imgV.sd_setImage(with: URL(string: m.userLogo), completed: nil)
                let lab = UILabel(frame: CGRect(x: imgV.frame.maxX - 8, y: -10, width: 20, height: 20))
                lab.textColor = .red
                lab.isHidden = m.replace_sign_up_number.toInt() == 0
                lab.text = "+\(m.replace_sign_up_number)"
                lab.font = UIFont.systemFont(ofSize: 10)
                imgV.superview?.addSubview(lab)
            } else {
                imgV.image = UIImage()
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
