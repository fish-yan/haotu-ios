//
//  String_FYExtension.swift
//  joint-operation
//
//  Created by Yan on 2018/11/30.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit
import YYText

extension String {
    
    func subString(from start: Int, to end: Int) -> String {
        let st = index(startIndex, offsetBy: start)
        let en = index(startIndex, offsetBy: end)
        return String(self[st..<en])
    }
    
    /// 字符串部分密文
    func secret(begin: Int, countDown: Int) -> String {
        if count < begin + countDown {
            return self
        }
        let strArray = self.map({String($0)})
        let a = ["*", "*", "*", "*"].prefix(4)
        let result = strArray.prefix(begin) + a + strArray.suffix(countDown)
        return result.joined()
    }
    
    /// 验证是否是手机号
    func isPhone() -> Bool {
        let mobRegex = "^1\\d{10}$"
        let phRegex = "^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$"
        let isMob = validateBy(mobRegex)
        let isPh = validateBy(phRegex)
        return isMob || isPh
    }
    
    /// 验证身份证
    func isIDCard() -> Bool {
        let regex = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"
        let isIDCard = validateBy(regex)
        guard isIDCard else { return false }
        let wArray = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let yArray = ["1", "0", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
        var sum = 0
        for i in 0..<17 {
            let char1 = self[index(startIndex, offsetBy: i)..<index(startIndex, offsetBy: i + 1)]
            guard let num1 = Int(char1) else { return false}
            let num2 = wArray[i]
            sum += num1 * num2
        }
        
        let mod = sum % 11
        guard let l = self.last else { return false }
        let last = String(l)
        if mod == 2 {
            return last == "X" || last == "x"
        } else {
            return last == yArray[mod]
        }
        
    }
    
    /// 验证邮箱
    func isEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return validateBy(regex)
    }
    
    /// 纯数字
    func isNumber() -> Bool {
        let regex = "^([0-9]*)$"
        return validateBy(regex)
    }
    
    /// 匹配数字 + 字母 + 汉字 + 指定特殊字符
    func match(_ min: Int, max: Int, hasCH: Bool = false, chars: String = "") -> Bool {
        let ch = hasCH ? "\\u4E00-\\u9FA5" : ""
        let regex = "^([A-Za-z0-9\(ch)\(chars)]{\(min),\(max)}$)"
        return validateBy(regex)
    }
    
    /// 清除多余空格及特殊空字符
    func clean() -> String {
        return replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
    /// 数值去除多余的0
    func removeLastZero() -> String {
        if contains(".") && last == "0" || last == "." {
            let str = String(dropLast())
            return str.removeLastZero()
        }
        return self
    }
    
    /// 去除结尾的*号
    func dropLastC(_ last: String = "*") -> String {
        if self.hasSuffix("*") {
            return String(dropLast()).dropLastC()
        }
        return self
    }
    
    /// 匹配
    private func validateBy(_ regex: String) -> Bool {
        let tempStr = self.clean()
        if tempStr.count == 0 { return false }
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: tempStr)
    }
    
    
    func find(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    
    func toInt() -> Int {
        let dob = Double(self)
        return Int(dob ?? 0.0)
    }
    
    func toFloat() -> CGFloat {
        let dob = Double(self)
        return CGFloat(dob ?? 0.0)
    }
    
    func toAmtFloat() -> CGFloat { //格式金额转换方法
        let dob = Double(self)
        return CGFloat(dob ?? 1.0)
    }
    
    /// 日期格式化 yyyyMMdd => yyyy-MM-dd
    func formatDate(_ from: String = "yyyy-MM-dd HH:mm:ss", to: String = "yyyy年MM月dd日") -> String {
        guard let date = Date(self, formatter: from)?.toString(to) else {
            print("格式化失败")
            return self
        }
        return date
    }
    
    /// base 64
    func base64() -> String {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return self
    }
    
    /// 添加...
    func dian() -> String {
        if self.count < 140 {
            return self
        }
        let new = self.subString(from: 0, to: 140)
        return "\(new)..."
    }
    
    func sh_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func sh_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func sh_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    func toAttContent() -> NSAttributedString {
        var idx = 0
        var arr1 = map{String($0)}
        let tempArr = arr1
        for (i, c) in tempArr.enumerated() {
            if c == "#" {
                arr1.insert("`", at: i + idx + idx % 2)
                idx += 1
            }
        }
        var str = arr1.joined()
        str = str.replacingOccurrences(of: "@", with: "`@")
        str = str.replacingOccurrences(of: " ", with: " `")
        let attrStr = NSMutableAttributedString()
        let arr = str.components(separatedBy: "`")
        for e in arr {
            if e.contains("#")  {
                let att = NSAttributedString(string: e, attributes: [.foregroundColor: UIColor(hex: 0xFFA700)])
                attrStr.append(att)
            } else if e.contains("@") {
                let att = NSAttributedString(string: e, attributes: [.foregroundColor: UIColor(hex: 0xFFA700)])
                attrStr.append(att)
            } else {
                attrStr.append(NSAttributedString(string: e))
            }
        }
        return attrStr
    }
    
    func toTags(_ width: CGFloat) -> NSAttributedString {
        let tagText = replacingOccurrences(of: "，", with: ",")
        let tags = tagText.components(separatedBy: ",")
        
        let attStr = NSMutableAttributedString()
        var height: CGFloat = 0
        for (i, tag) in tags.enumerated() {
            let one = NSMutableAttributedString(string: tag)
            one.yy_font = UIFont.systemFont(ofSize: 11)
            var color: UIColor
            if i % 2 == 0 {
                color = UIColor(hex: 0xFA375C)
            } else {
                color = UIColor(hex: 0xFFA700)
            }
            one.yy_color = color
            let border = YYTextBorder()
            border.cornerRadius = 2
            border.strokeColor = color
            border.strokeWidth = 0.5
            border.lineStyle = .single
            border.insets = UIEdgeInsets(top: -3, left: -5, bottom: -3, right: -5)
            one.yy_textBorder = border
            
            let tempAttr = attStr.mutableCopy() as! NSMutableAttributedString
            tempAttr.append(NSAttributedString(string: "   "))
            tempAttr.append(one)
            let container = YYTextContainer(size: CGSize(width: width, height: 100))
            let layout = YYTextLayout(container: container, text: tempAttr)
            let h = layout?.textBoundingSize.height ?? 0
            if h - height > 10 {
                if height != 0 {
                    attStr.append(NSAttributedString(string: "\n"))
                }
                height = h
            }
            attStr.append(NSAttributedString(string: "   "))
            attStr.append(one)
            attStr.append(NSAttributedString(string: "   "))
        }
        attStr.yy_lineSpacing = 10
        return attStr
    }
    
}



