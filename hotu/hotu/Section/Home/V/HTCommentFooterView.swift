//
//  HTCommentFooterView.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/26.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTCommentFooterView: UIView {

    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var imgV: UIImageView!
    
    var moreAction: ((UIButton)->Void)?
    
    
    var openType: HTCommentOpenType = .close {
        didSet {
            let name = openType == .finish ? "icon_next_up" : "icon_next_down"
            imgV.image = UIImage(named: name)
            let tit = openType == .finish ? "收起" : "展开"
            moreBtn.setTitle("——     \(tit)\(count)条回复", for: .normal)
        }
    }
    
    var count = 0 {
        didSet {
            let tit = openType == .finish ? "收起" : "展开"
            moreBtn.setTitle("——     \(tit)\(count)条回复", for: .normal)
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
        let oneView = UINib(nibName: "HTCommentFooterView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        oneView.frame = bounds
        addSubview(oneView)
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        if let m = moreAction {
            m(sender)
        }
    }
}
