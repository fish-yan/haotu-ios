//
//  CALayer_FYExtension.swift
//  joint-operation
//
//  Created by Yan on 2018/12/1.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit

extension CALayer {
    
    @objc var bColor: UIColor {
        set{
            borderColor = newValue.cgColor
        }
        get{
            return UIColor(cgColor: borderColor ?? UIColor.black.cgColor)
        }
    }
    
    @objc var sColor: UIColor {
        set{
            shadowColor = newValue.cgColor
        }
        get{
            return UIColor(cgColor: shadowColor ?? UIColor.gray.cgColor)
        }
    }
}