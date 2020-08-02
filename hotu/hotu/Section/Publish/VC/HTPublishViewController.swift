//
//  HTPublishViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/24.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit
import YYText

enum HTPickerType {
    case video, image
}

class HTPublishViewController: UIViewController {
    
    @IBOutlet weak var contentTV: HTAttTextView!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet var vs: [UIView]!
    @IBOutlet var imgVs: [UIImageView]!
    @IBOutlet weak var videoImgV: UIImageView!
    @IBOutlet weak var assoTF: UITextField!
    
    @IBOutlet weak var associationV: UIView!
    var publish = TXUGCPublish()
        
    var imgs = [Any]()
    
    var vm = HTPublishVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTV.delegate = self
        contentTV.placeholderText = vm.type == .video ? "请输入您的想法" : "请输入您的想法，最多可上传9张图片"
        associationV.isHidden = HTUserInfo.share.role == .normal
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.content = contentTV.text
        if vm.type == .video {
            vm.requestPublishVideo { (videoModel) in
                Toast("发布成功")
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .HTVideoChanged, object: videoModel)
            }
        } else {
            vm.imgs = imgs.filter({$0 is UIImage}) as! [UIImage]
            vm.requestPublishImgs { (success) in
                Toast("发布成功")
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .HTVideoChanged, object: nil)
            }
        }
    }
    
    @IBAction func topicAction(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        view.endEditing(true)
       let title = "\(HTUserInfo.share.province)\(HTUserInfo.share.city)\(HTUserInfo.share.area)\(HTUserInfo.share.address)"
        sender.setTitle(title, for: .selected)
        sender.setImage(UIImage(), for: .selected)
        sender.isSelected = !sender.isSelected
        vm.address = sender.isSelected ? HTUserInfo.share.address : ""
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        view.endEditing(true)
        if let  v = sender.superview,
            let imgV = v.viewWithTag(v.tag + 100) as? UIImageView,
            imgV.image != nil{
            return
        }
        showAlert()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        view.endEditing(true)
        if let v = sender.superview {
            imgs.remove(at: v.tag)
            setImageV()
        }
    }
    
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ti = vm.type == .video ? "录制" : "拍照上传"
        let action1 = UIAlertAction(title: ti, style: .default) { (action) in
            if self.vm.type == .video {
                self.onrecordVieo()
            } else {
                HTImagePickerUtil.share.pickPhoto(with: .camera) { (image) in
                    self.imgs.append(image)
                    self.setImageV()
                }
            }
        }
        let action2 = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.onSelectVideo()
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel,  handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func onSelectVideo() {
        let isVideo = vm.type == .video
        let picker = QBImagePickerController()
        picker.delegate = self
        picker.mediaType = isVideo ? .video : .image
        picker.allowsMultipleSelection = !isVideo
        picker.showsNumberOfSelectedAssets = !isVideo
        let max: UInt = UInt(Swift.max(9 - self.imgs.count, 0))
        picker.maximumNumberOfSelection = isVideo ? 1 : max
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
    }
    
    private func onrecordVieo() {
        let config = VideoRecordConfig()
        let recordVC = VideoRecordViewController(configure: config)
        recordVC?.onRecordCompleted = { result in
            guard let re = result else {return}
            let editVC = VideoEditViewController()
            editVC.videoPath = re.videoPath
            editVC.onEditCompleted = { result in
                self.uploadVideo(result)
            }
            recordVC?.navigationController?.pushViewController(editVC, animated: true)
        }
        
        if let rvc = recordVC {
            let nav = UINavigationController(rootViewController: rvc)
            nav.modalPresentationStyle = .overFullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    private func setImageV() {
        let manager = PHImageManager.default()
        for v in vs {
            if let imgV = v.viewWithTag(v.tag + 100) as? UIImageView {
                if v.tag < imgs.count {
                    if let asset = imgs[v.tag] as? PHAsset {
                        let option = PHImageRequestOptions()
                        option.isNetworkAccessAllowed = true
                        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: option) { (image, info) in
                            if let img = image {
                                self.imgs[v.tag] = img
                                imgV.image = img
                            }
                            imgV.image = image
                        }
                    }
                    if let img = imgs[v.tag] as? UIImage {
                        imgV.image = img
                    }
                } else {
                    imgV.image = nil
                }
            }
            if let deleteBtn = v.viewWithTag(v.tag + 1000) as? UIButton {
                deleteBtn.isHidden = v.tag >= self.imgs.count
            }
            v.isHidden =  v.tag > self.imgs.count
        }
        v1.isHidden = imgs.count < 3
        v2.isHidden = imgs.count < 6
    }
    
    private func uploadVideo(_ result: TXUGCRecordResult?) {
        guard let res = result else {
            Toast("视频编辑失败")
            return
        }
        
//        let edi = TXVideoEditer()
//        edi.setVideoPath(res.videoPath)
//        edi.generateVideo(.VIDEO_COMPRESSED_540P, videoOutputPath: res.videoPath)
        
        vm.requestSign { (sign) in
            let params = TXPublishParam()
            params.signature = sign
            params.videoPath = res.videoPath
            let fileNm = "TXUGC_" + Date().toString("yyyyMMdd_HHmmss") + ".jpg"
            guard let filePath = HTFileUtil.save(image: res.coverImage, name: fileNm) else {
                Toast("保存图片失败")
                return
            }
            params.coverPath = filePath
            self.publish.delegate = self
            self.publish.publishVideo(params)
            showHUD()
        }
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTTopicList" {
            let vc = segue.destination as! HTTopicListViewController
            vc.complete = { topic in
                self.vm.topicArr.append(topic)
                var text = self.contentTV.text ?? ""
                text += "#\(topic.content)# "
                self.contentTV.attributedText = NSAttributedString(string: text)
                self.contentTV.becomeFirstResponder()
                let position = self.contentTV.endOfDocument
                self.contentTV.selectedTextRange = self.contentTV.textRange(from: position, to: position)
            }
        } else if segue.identifier == "HTFriend" {
            let vc = segue.destination as! HTFriendViewController
            vc.complete = { (model) in
                var text = self.contentTV.text ?? ""
                text += "@\(model.nick_name) "
                self.contentTV.attributedText = NSAttributedString(string: text)
                if model.user_id.isEmpty { // 通讯录
                    self.vm.phoneArr.append(model)
                } else { // 好友
                    self.vm.userArr.append(model)
                }
                self.contentTV.becomeFirstResponder()
                let position = self.contentTV.endOfDocument
                self.contentTV.selectedTextRange = self.contentTV.textRange(from: position, to: position)
            }
        } else if segue.identifier == "HTAssociation" {
            let vc = segue.destination as! HTAssociationViewController
            vc.completeActivity = { model in
                self.assoTF.text = model.groupName
                self.vm.groupId = model.activityId
                self.vm.groupType = "3"
            }
            vc.completeClub = { model in
                self.assoTF.text = model.group_name
                self.vm.groupId = model.group_id
                self.vm.groupType = "5"
            }
            vc.completeCoach = { model in
                self.assoTF.text = model.group_name
                self.vm.groupId = model.group_id
                self.vm.groupType = "4"
            }
            vc.completeMerc = { model in
                self.assoTF.text = model.group_name
                self.vm.groupId = model.group_id
                self.vm.groupType = "1"
            }
        }
    }
    
}

extension HTPublishViewController: QBImagePickerControllerDelegate, TXVideoPublishListener {
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        if vm.type == .video {
            let videoVC = VideoLoadingController()
            videoVC.composeMode = .edit
            videoVC.onEditCompleted = { result in
                self.uploadVideo(result)
            }
            dismiss(animated: true) {
                let nav = UINavigationController(rootViewController: videoVC)
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: true, completion: nil)
                videoVC.exportAssetList(assets, assetType: .video)
            }
        } else {
            imgs += assets
            setImageV()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func onPublishComplete(_ result: TXPublishResult!) {
        hidHUD()
        self.vm.url = result.videoURL
        self.vm.tencentVideoId = result.videoId
        self.vm.coverUrl = result.coverURL
        self.imgVs.first?.sd_setImage(with: URL(string: result.coverURL), completed: nil)
        videoImgV.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}

extension HTPublishViewController: YYTextViewDelegate {
    func textViewDidChange(_ textView: YYTextView) {
        if textView.text.isEmpty {
            textView.textColor = .black
        }
    }
}
