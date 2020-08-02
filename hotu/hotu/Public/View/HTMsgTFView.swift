//
//  HTMsgTFView.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/23.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTMsgTFView: UIView {
    
    @IBOutlet weak var emojiView: HTEmojiView!
        
    @IBOutlet weak var msgTV: HTAttTextView!
    
    @IBOutlet weak var emojiBtn: UIButton!
    
    private var oneView: UIView!
    
    var emojiAction: ((CGFloat)->Void)?
    
    var atAction:(()->Void)?
    
    var height = 50
    
    var text: String {
        set {
            self.msgTV.attributedText = NSAttributedString(string: newValue)
        }
        get {
            return msgTV.text
        }
    }
    
    var placeholderText: String? {
        set {
            self.msgTV.placeholderText = newValue
        }
        get {
            return msgTV.placeholderText
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
        backgroundColor = .clear
        oneView = UINib(nibName: "HTMsgTFView", bundle: nil).instantiate(withOwner: self, options: nil).last as? UIView
        oneView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 270)
        addSubview(oneView)
        msgTV.returnKeyType = .send
        emojiView.complete = { str in
            if str == "D" {
                self.msgTV.deleteBackward()
            } else {
                let text = self.msgTV.text ?? ""
                self.msgTV.text = text + str
            }
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        let b = self.msgTV.becomeFirstResponder()
        let position = self.msgTV.endOfDocument
        self.msgTV.selectedTextRange = self.msgTV.textRange(from: position, to: position)
        return b
    }

    @IBAction func emojiAction(_ sender: UIButton) {
        if let e = emojiAction {
            e(height == 50 ? 270 : 50)
        }
    }
    
    @IBAction func atAction(_ sender: UIButton) {
        if let a = atAction {
            a()
        }
    }
}
