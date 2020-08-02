//
//  UIColor_FYExtension.swift
//  joint-operation
//
//  Created by Yan on 2018/12/1.
//  Copyright © 2018 Yan. All rights reserved.
//

import Foundation
import UIKit


// MARK : 颜色类扩展
extension UIColor {
    
    //便利构造器 --
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
