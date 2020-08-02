//
//  FYFlutterViewController.swift
//  hotu
//
//  Created by yan on 2020/5/14.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit
import Flutter

class FYFlutterViewController: FlutterViewController {

    let platform = "hotu.modul.channel"
    
    lazy var channel = FlutterMethodChannel(name: platform, binaryMessenger: binaryMessenger)
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configChannel()
        channel.invokeMethod("statusBarHeight", arguments: UIApplication.shared.statusBarFrame.height)
        channel.invokeMethod("setTokenId", arguments: HTUserInfo.share.tokenId)
        var isDebug = 0
        #if DEBUG
        isDebug = 0
        #else
        isDebug = 1
        #endif
        channel.invokeMethod("isDebug", arguments: isDebug)

    }
    
    func configChannel() {
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "closeFlutter":
                self.navigationController?.popViewController(animated: true)
            case "loginout":
                HTUserInfo.share.clearUserInfo()
            case "getVersion":
                if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    result(v)
                }
            default:break
            }
        }
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
