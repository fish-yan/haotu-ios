//
//  FYScrollView.swift
//  joint-operation
//
//  Created by Yan on 2018/12/4.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit

class FYScrollView: UIView {
    
    var timer: Timer?
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: bounds)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var imgArray = [String]() {
        didSet{
            CATransaction.setCompletionBlock {
                self.configureImgV()
            }
        }
    }
    
    var currentPage = 0 {
        didSet {
            if let pageChange = self.pageChange {
                pageChange(currentPage)
            }
        }
    }
    
    var pageChange: ((Int)->Void)?
    
    var tapAction: ((Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        CATransaction.setCompletionBlock {
             self.addSubview(self.scrollView)
        }
    }

    
    private func configureImgV() {
        if imgArray.count == 0 { return }
        for sub in scrollView.subviews {
            sub.removeFromSuperview()
        }
        var tempImgArray = imgArray
        if imgArray.count > 1 {
            let first = imgArray.first!
            let last = imgArray.last!
            tempImgArray.insert(first, at: imgArray.count)
            tempImgArray.insert(last, at: 0)
        }
        for i in 0..<tempImgArray.count {
            let x = bounds.width * CGFloat(i)
            let imgNm = tempImgArray[i]
            let imgV = UIImageView(frame: CGRect(x: x, y: 0, width: bounds.width, height: bounds.height))
         //   imgV.image = UIImage(named: imgNm)
            if let url = imgNm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                imgV.sd_setImage(with: URL(string: url), completed: nil)
            }
            imgV.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            imgV.addGestureRecognizer(tap)
            imgV.tag = i
            if imgArray.count > 1 {
                imgV.tag = i - 1
                if i == 0 {
                    imgV.tag = tempImgArray.count - 3
                }
                if i == tempImgArray.count - 1 {
                    imgV.tag = 0
                }
            }
            scrollView.addSubview(imgV)
        }
        scrollView.contentSize = CGSize(width: CGFloat(tempImgArray.count) * bounds.width, height: bounds.height)
        if imgArray.count > 1 {
            addTimer()
            scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        }else{
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func addTimer() {
        if timer != nil {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func timerAction() {
        // 化整
        scrollView.contentOffset.x = CGFloat(Int(scrollView.contentOffset.x / bounds.width)) * bounds.width
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + bounds.width, y: 0), animated: true)
    }
    
    @objc func tapGestureAction(_ tap: UIGestureRecognizer) {
        if let tapAction = self.tapAction {
            tapAction(tap.view?.tag ?? 0)
        }
    }
    
}

extension FYScrollView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer?.fireDate = Date(timeIntervalSinceNow: 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imgArray.count <= 1 { return }
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = CGFloat(imgArray.count) * bounds.width
        }
        if scrollView.contentOffset.x == CGFloat(imgArray.count + 1) * bounds.width {
            scrollView.contentOffset.x = bounds.width
        }
        // 超出范围归0
        if scrollView.contentOffset.x > CGFloat(imgArray.count + 1) * bounds.width {
            scrollView.contentOffset.x = 0
        }
        
        var current = Int(scrollView.contentOffset.x + scrollView.bounds.width/2) / Int(scrollView.bounds.width)
        if current == 0 {
            current = imgArray.count
        }
        if current == imgArray.count + 1 {
            current = 1
        }
        current -= 1
        if currentPage != current {
            currentPage = current
        }
    }
    
}
