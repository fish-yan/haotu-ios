//
//  LZMenuViewController.swift
//  Lvzhou_Example
//
//  Created by Yan on 2019/4/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

open class FYMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var dataArr = [String]()
    
    public var complete:((String)->Void)?
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.cornerRadius = 6
        view.superview?.layer.masksToBounds = false
        view.layer.masksToBounds = true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if UMSocialManager.default()?.isInstall(.QQ) == false && !WXApi.isWXAppInstalled() {
            dataArr = dataArr.filter({!$0.contains("分享")})
        }
        preferredContentSize = CGSize(width: 110, height: dataArr.count * 33 - 1)
        let rect = popoverPresentationController?.sourceView?.frame ?? CGRect.zero
        let trailing = UIScreen.main.bounds.width - rect.maxX
        popoverPresentationController?.sourceRect = CGRect(x: rect.width - 40 + trailing, y: 0, width: 10, height: rect.height/3 * 2)
        popoverPresentationController?.backgroundColor = view.backgroundColor
        popoverPresentationController?.popoverBackgroundViewClass = LZPopoverBackgroundView.self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FYMenuViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true) {
            if let complete = self.complete {
                complete(self.dataArr[indexPath.row])
            }
        }
    }
}

class LZPopoverBackgroundView: UIPopoverBackgroundView {
    
    private var direction: UIPopoverArrowDirection = .up
    
    private var offset: CGFloat = 0
    
    override var arrowDirection: UIPopoverArrowDirection {
        set{
            direction = newValue
        }
        get {
            return direction
        }
    }
    
    override var arrowOffset: CGFloat {
        set {
            offset = newValue
        }
        get {
            return offset
        }
    }
    
    var arrowImageV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(arrowImageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let arrowSize = CGSize(width: LZPopoverBackgroundView.arrowBase(), height: LZPopoverBackgroundView.arrowHeight())
        arrowImageV.image = drawArrowImage(arrowSize)
        var x: CGFloat = 0
        var y: CGFloat = 0
        switch arrowDirection {
        case .up:
            x = (bounds.width - arrowSize.width)/2 + arrowOffset
        case .down:
            x = (bounds.width - arrowSize.width)/2 + arrowOffset
            y = bounds.height - arrowSize.height
        case .left:
            y = (bounds.height - arrowSize.height)/2 + arrowOffset
        case .right:
            x = bounds.width - arrowSize.width
            y = (bounds.height - arrowSize.height)/2 + arrowOffset
        default:
            break
        }
        arrowImageV.frame = CGRect(origin: CGPoint(x: x, y: y), size: arrowSize)
                
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5
    }
    
    func drawArrowImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let ctx = UIGraphicsGetCurrentContext() else {return nil}
        UIColor.clear.setFill()
        ctx.fill(CGRect(origin: .zero, size: size))
        var point1 = CGPoint.zero
        var point2 = CGPoint.zero
        var point3 = CGPoint.zero
        switch arrowDirection {
        case .up:
            point1 = CGPoint(x: size.width/2, y: 0)
            point2 = CGPoint(x: size.width, y: size.height)
            point3 = CGPoint(x: 0, y: size.height)
        case .down:
            point1 = CGPoint(x: 0, y: 0)
            point2 = CGPoint(x: size.width, y: 0)
            point3 = CGPoint(x: size.width/2, y: size.height)
        case .left:
            point1 = CGPoint(x: 0, y: size.height/2)
            point2 = CGPoint(x: size.width, y: 0)
            point3 = CGPoint(x: size.width, y: size.height)
        case .right:
            point1 = CGPoint(x: 0, y: 0)
            point2 = CGPoint(x: size.width, y: size.height/2)
            point3 = CGPoint(x: 0, y: size.height)
        default:
            break
        }
        let arrowPath = CGMutablePath()
        arrowPath.move(to: point1)
        arrowPath.addLine(to: point2)
        arrowPath.addLine(to: point3)
        arrowPath.closeSubpath()
        ctx.addPath(arrowPath)
        let fillColor = UIColor(white: 0, alpha: 0.7).cgColor
        ctx.setFillColor(fillColor)
        ctx.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override static func arrowBase() -> CGFloat {
        return 15
    }
    
    override static func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    override static func arrowHeight() -> CGFloat {
        return 10
    }
    
}
