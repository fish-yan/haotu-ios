//
//  HTPayHeader.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/11.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPayHeader: UIView {

    @IBOutlet weak var titleLab: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        let oneView = UINib(nibName: "HTPayHeader", bundle: nil).instantiate(withOwner: self, options: nil).last as! UIView
        oneView.frame = bounds
        addSubview(oneView)
    }
}
