//
//  HTAttTextView.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/10.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

class HTTextParser: NSObject, YYTextParser {
    private var rgx: NSRegularExpression!
    var textColor = UIColor.black
    var bindColor = UIColor(hex: 0xFFA700)
    override init() {
        super.init()
        let pattern = "(@[\\S]+[ ,\\n]|#[\\S]+#[ ,\\n])"
        do {
            rgx = try NSRegularExpression(pattern: pattern, options: [])
        } catch let e {
            print(e)
        }
    }
    
    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        var change = false
        guard let t = text else {return false}
        var lastLocation = t.length
        rgx.enumerateMatches(in: t.string, options: .withoutAnchoringBounds, range: t.yy_rangeOfAll()) { (result, flag, pointer) in
            guard let res = result else {return}
            let range = res.range
            if range.location == NSNotFound || range.length < 1 {return}
            let bindRange = NSMakeRange(range.location, range.length - 1)
            let binding = YYTextBinding(deleteConfirm: true)
            t.yy_setTextBinding(binding, range: bindRange)
            t.yy_setColor(bindColor, range: bindRange)
            lastLocation = bindRange.location + bindRange.length
            change = true
        }
        t.yy_setColor(textColor, range: NSMakeRange(lastLocation, t.length - lastLocation))
        return change
    }
}

class HTAttTextView: YYTextView {
    
    var bindColor = UIColor(hex: 0xFFA700)
    
    var tColor = UIColor.black {
        didSet {
            let p = HTTextParser()
            p.textColor = tColor
            p.bindColor = bindColor
            textParser = p
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        textParser = HTTextParser()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textParser = HTTextParser()
    }
    
}
