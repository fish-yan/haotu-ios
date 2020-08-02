//
//  JOWebViewController.swift
//  joint-operation
//
//  Created by Yan on 2018/11/30.
//  Copyright © 2018 Yan. All rights reserved.
//

import UIKit
import WebKit

class FYWebViewController: UIViewController {
    
    @discardableResult
    static func open(_ url: String) -> FYWebViewController {
        let webV = FYWebViewController()
        webV.urlStr = url
        webV.hidesBottomBarWhenPushed = true
        visibleViewController?.navigationController?.pushViewController(webV, animated: true)
        return webV
    }

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //允许视频块内播放
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 44 - UIApplication.shared.statusBarFrame.height), configuration: config)
        webView.navigationDelegate = self
        return webView
    }()
    
    lazy var progress: UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        progress.tintColor = UIColor(hex: 0x397BE6)
        progress.trackTintColor = .clear
        return progress
    }()
    
    var urlStr = ""
        
    var shareTitle = ""
    
    var shareDes = ""
    var shareImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progress)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var url: URL!
        if urlStr.hasPrefix("https://") || urlStr.hasPrefix("http://") {
            var u = urlStr
            if u.contains("?") {
                u += "&tokenId=\(HTUserInfo.share.tokenId)"
            } else {
                u += "?tokenId=\(HTUserInfo.share.tokenId)"
            }
            if u.contains("isapp") {
                u = u.replacingOccurrences(of: "isapp=0", with: "isapp=1")
            } else {
                u += "&isapp=1"
            }
            if let temp =  URL(string: u) {
                url = temp
            }
        } else if urlStr.hasPrefix("/") {
            url = URL(fileURLWithPath: urlStr)
        } else {
            Toast("url解析错误")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
        requestShareAd()
    }
    
    func requestShareAd() {
        var adId = ""
        if let pars = urlStr.components(separatedBy: "?").last{
            for str in pars.components(separatedBy: "&") {
                if str.contains("adId=") {
                    adId = str.replacingOccurrences(of: "adId=", with: "")
                }
            }
        }
        if adId.isEmpty {return}
        FYNetWork.request(API + "adversiment/posting/savings/getAdvertisimentInfo",params: ["advertisementId":adId]).responseJSON { (json) in
            self.shareTitle = json["data"]["title"].stringValue
            self.shareDes = json["data"]["remark"].stringValue
            self.shareImg = json["data"]["linkUrl"].stringValue
            if !self.shareTitle.isEmpty {
                let item = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(self.shareAction))
                item.tintColor = .black
                self.navigationItem.rightBarButtonItem = item
            }
        }
    }
    
    @objc func shareAction() {
        SDWebImageDownloader.shared.downloadImage(with: URL(string: shareImg)) { (img, data, err, b) in
            var u = self.urlStr
            if u.contains("isapp") {
                u = u.replacingOccurrences(of: "isapp=1", with: "isapp=0")
            } else {
                u += "&isapp=0"
            }
            let shareVC = FYShareViewController(u, title: self.shareTitle, des: self.shareDes, img: img)
            self.present(shareVC, animated: true, completion: nil)
        }
    }
    
    override func navigationShouldPop() -> Bool  {
        if webView.canGoBack {
            webView.goBack()
            return false
        } else {
            return true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(webView.estimatedProgress)
            progress.isHidden = progress.progress == 1
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

}

extension FYWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}
