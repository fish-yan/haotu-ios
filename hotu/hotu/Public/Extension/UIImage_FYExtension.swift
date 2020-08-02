
//
//  UIImage_FYExtension.swift
//  joint-operation
//
//  Created by Yan on 2018/12/1.
//  Copyright © 2018 Yan. All rights reserved.
//

import Foundation

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgimg = image?.cgImage {
            self.init(cgImage: cgimg)
        } else {
            return nil
        }
    }
    
    func toHex(_ size: Float = 500) -> String {
        let data = archive(to: size)
        return data.toHex()
    }
    
    func archive(size: Float = 1024) -> UIImage? {
        return UIImage(data: archive(to: size))
    }
    
    func archive(to size: Float) -> Data {
        return archive(self, size: size)
    }
    
    private func archive(_ img: UIImage, size: Float) -> Data {
        guard let data = img.jpegData(compressionQuality: 1) else { return Data() }
        let count = Float(data.count) / 1024
        let rate = size/count
        guard let archiveData = img.jpegData(compressionQuality: CGFloat(rate)) else { return Data() }
        if Float(archiveData.count) / 1024 > size {
            guard let minImg = UIImage(data: archiveData) else { return Data() }
            let imgSize = CGSize(width: minImg.size.width * 0.7, height: minImg.size.height * 0.7)
            UIGraphicsBeginImageContext(imgSize)
            minImg.draw(in: CGRect(origin: CGPoint.zero, size: imgSize))
            guard let tempImg = UIGraphicsGetImageFromCurrentImageContext() else { return Data() }
            UIGraphicsEndImageContext()
            return archive(tempImg, size: size)
        }
        return archiveData
    }
    
    /// 生成二维码
    convenience init?(qrCode: String) {
        if let cgImg = UIImage.createQRCode(qrCode) {
            self.init(cgImage: cgImg)
        } else {
            return nil
        }
    }
    
    private static func createQRCode(_ url: String) -> CGImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = url.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        guard let ciImg = filter?.outputImage else { return nil }
        return createUIImage(ciImg)
    }
    
    private static func createUIImage(_ ciImg: CIImage) -> CGImage? {
        let scale = 200 / ciImg.extent.size.width
        let space = CGColorSpaceCreateDeviceRGB()
        guard let cgContext = CGContext(data: nil, width: 200, height: 200, bitsPerComponent: 8, bytesPerRow: 200 * 4, space: space, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else { return nil }
        let ciContext = CIContext(options: nil)
        guard let cgImg =  ciContext.createCGImage(ciImg, from: ciImg.extent) else {return nil}
        cgContext.interpolationQuality = .none
        cgContext.scaleBy(x: scale, y: scale)
        cgContext.draw(cgImg, in: ciImg.extent)
        return cgContext.makeImage()
    }
    
    func clipImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let x = (self.size.width - size.width) / 2
        let y = (self.size.height - size.height) / 2
        draw(in: CGRect(x: x, y: y, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}


extension Data {
    func toHex() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
    
