//
//  HTSearchTFHeader.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/21.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTSearchTFHeader: UIView, UITextFieldDelegate {

    @IBOutlet weak var searchTF: UITextField!
    
    var tfReturnAction: ((UITextField)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    func loadView() {
        let oneView = UINib(nibName: "HTSearchTFHeader", bundle: nil).instantiate(withOwner: self, options: nil).last as! UIView
        oneView.frame = bounds
        addSubview(oneView)
        clipsToBounds = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let t = tfReturnAction {
            t(textField)
        }
        return true
    }
}
