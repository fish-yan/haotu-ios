//
//  HTFileUtil.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTFileUtil: NSObject {
    
    @discardableResult
    static func save(image: UIImage, name: String) -> String? {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = docPath + "/\(name)"
        guard let data = image.jpegData(compressionQuality: 1) else {return nil}
            let url = URL(fileURLWithPath: filePath)
        do {
            try data.write(to: url, options: Data.WritingOptions.atomic)
            return filePath
        } catch let pattern {
            print(pattern)
            return nil
        }
    }
    
    static func getImage(name: String) -> UIImage? {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = docPath + "/\(name)"
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch let pattern {
            print(pattern)
            return nil
        }
        
    }
}
