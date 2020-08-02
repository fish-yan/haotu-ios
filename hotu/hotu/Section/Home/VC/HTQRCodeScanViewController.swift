//
//  HTQRCodeScanViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/18.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import RongIMKit

class HTQRCodeScanViewController: UIViewController {
    
    @IBOutlet weak var camV: UIView!
    @IBOutlet weak var scanView: UIView!
    
    @IBOutlet weak var lineV: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    var complete: ((Bool)->Void)?
    
    var clubVM = HTClubVM()
    
    var input: AVCaptureDeviceInput?
    
    var output = AVCaptureMetadataOutput()
        
    var device: AVCaptureDevice?
    
    var session = AVCaptureSession()
    
    var captureLayer: AVCaptureVideoPreviewLayer!
    
    var an: CABasicAnimation!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        session.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configView() {
        let width = SCREEN_WIDTH * 0.6
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let img = UIImage(color: .white, size: CGSize(width: width, height: width))
        maskLayer.contents = img?.cgImage
        maskLayer.contentsGravity = .center
        maskLayer.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor
        camV.layer.mask = maskLayer
    }
    
    private func configSession() {
        session.sessionPreset = .high
        configInput()
        if let ip = input,
            session.canAddInput(ip) {
            session.addInput(ip)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        let width = SCREEN_WIDTH * 0.7
        let x = ((SCREEN_WIDTH - width) / 2) / SCREEN_WIDTH
        let y = ((SCREEN_HEIGHT - width) / 2) / SCREEN_HEIGHT
        let rect  = CGRect(x: y, y: x, width: width / SCREEN_HEIGHT, height: width / SCREEN_WIDTH)
        print("rect = \(rect)")
        
        output.rectOfInterest = rect
        captureLayer = AVCaptureVideoPreviewLayer(session: session)
        captureLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        captureLayer.videoGravity = .resizeAspectFill
        camV.layer.insertSublayer(captureLayer, at: 0)
    }
    
    private func configInput() {
        device = AVCaptureDevice.default(for: .video)
        if let d = device {
            do {
                input = try AVCaptureDeviceInput(device: d)
            } catch let e {
                print(e)
            }
        }
    }
    
    private func animate() {
        an = CABasicAnimation(keyPath: "position.y")
        an.duration = 3
        an.repeatCount = Float.greatestFiniteMagnitude
        an.isRemovedOnCompletion = false
        an.fromValue = -50
        an.toValue = scanView.frame.height + 50
        lineV.layer.add(an, forKey: "an")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectImgAction(_ sender: UIButton) {
        HTImagePickerUtil.share.pickPhoto(with: .savedPhotosAlbum) { (img) in
            self.scanQRCode(img)
        }
    }
    
    private func scanQRCode(_ img: UIImage) {
        guard let cgimg = img.cgImage else {return}
        let image = CIImage(cgImage: cgimg)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        if let feature = detector?.features(in: image).first as? CIQRCodeFeature {
            parseQR(feature.messageString)
        }
    }
    
    private func parseQR(_ text: String?) {
        session.stopRunning()
        lineV.isHidden = true
        lineV.layer.removeAnimation(forKey: "an")
        if let value = text,
            !value.isEmpty,
            let str = value.components(separatedBy: "?").last {
            var id = ""
            var type = ""
            var subType = ""
            for e in str.components(separatedBy: "&") {
                if e.contains("id") {
                    if let d = e.components(separatedBy: "=").last {
                        id = d
                    }
                }
                if e.contains("type") {
                    if let t = e.components(separatedBy: "=").last {
                        type = t
                    }
                }
                if e.contains("category") {
                    if let t = e.components(separatedBy: "=").last {
                        subType = t
                    }
                }
            }
            if id.isEmpty {
                Toast("未识别到二维码")
                return
            }
            switch type {
            case "1": // 个人码
                let story = UIStoryboard(name: "Mine", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "HTMineViewController") as! HTMineViewController
                vc.mineVM.userId = id
                navigationController?.pushViewController(vc, animated: true)
            case "2": // 群码
                let story = UIStoryboard(name: "Mine", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "HTClubDetail2ViewController") as! HTClubDetail2ViewController
                vc.clubVM.model.group_id = id
                navigationController?.pushViewController(vc, animated: true)
            case "3": // 活动
                let story = UIStoryboard(name: "Home", bundle: nil)
                if subType == "0" {
                    let vc = story.instantiateViewController(withIdentifier: "HTActivityDetailViewController") as! HTActivityDetailViewController
                    vc.vm.model.activityId = id
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = story.instantiateViewController(withIdentifier: "HTMatchDetailViewController") as! HTMatchDetailViewController
                    vc.vm.model.activityId = id
                    navigationController?.pushViewController(vc, animated: true)
                }
            case "4": // 商品
                let story = UIStoryboard(name: "Home", bundle: nil)
                if subType == "1" {
                    let vc = story.instantiateViewController(withIdentifier: "HTProductDetailViewController") as! HTProductDetailViewController
                    vc.vm.productId = id
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = story.instantiateViewController(withIdentifier: "HTCourseDetailViewController") as! HTCourseDetailViewController
                    vc.vm.productId = id
                    navigationController?.pushViewController(vc, animated: true)
                }
            case "5": // 直播
                let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HTLiveDetailViewController") as! HTLiveDetailViewController
                vc.vm.activityId = id
                navigationController?.pushViewController(vc, animated: true)
            default:
                joinClub(id)
                return
            }
            CATransaction.setCompletionBlock {
                if var vcs = self.navigationController?.viewControllers {
                    vcs.removeAll(where: {$0 == self})
                    self.navigationController?.viewControllers = vcs
                }
            }
        } else {
            Toast("非好兔二维码")
            self.session.startRunning()
            self.lineV.isHidden = false
            self.animate()
            
        }
    }
    
    private func joinClub(_ id: String) {
        clubVM.model.group_id = id
        clubVM.requestClubDetail { [weak self] (success) in
            if success {
                self?.clubVM.requestJoinClub { (success) in
                    if success {
                        self?.sendSysMsg()
                    } else {
                        self?.session.startRunning()
                        self?.lineV.isHidden = false
                        self?.animate()
                    }
                }
            } else {
                self?.session.startRunning()
                self?.lineV.isHidden = false
                self?.animate()
            }
        }
    }
    
    private func sendSysMsg() {
        let noti = RCGroupNotificationMessage()
        noti.message = "\(HTUserInfo.share.userName) 加入了群组"
        noti.operation = GroupNotificationMessage_GroupOperationAdd
        noti.operatorUserId = HTUserInfo.share.userId
        
        noti.data = HTUserInfo.share.userName
        RCIM.shared()?.sendMessage(.ConversationType_GROUP, targetId: clubVM.model.group_id, content: noti, pushContent: "", pushData: "", success: { (msgId) in
            DispatchQueue.main.async {
                self.pushToConversationVC()
            }
        }, error: { (error, msgId) in
            print(error.rawValue)
        })
        
    }
    
    private func pushToConversationVC() {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HTConversationViewController") as! HTConversationViewController
        vc.conversationType = .ConversationType_GROUP
        vc.targetId = clubVM.model.group_id
        vc.title = clubVM.model.group_name
        navigationController?.pushViewController(vc, animated: true)
        CATransaction.setCompletionBlock {
            if var vcs = self.navigationController?.viewControllers {
                vcs.removeAll(where: {$0 == self})
                self.navigationController?.viewControllers = vcs
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

extension HTQRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let obj = metadataObjects.last as? AVMetadataMachineReadableCodeObject {
            parseQR(obj.stringValue)
        }
    }
}
