//
//  HTLiveAuthViewController.swift
//  hotu
//
//  Created by 薛焱 on 2020/4/23.
//  Copyright © 2020 薛焱. All rights reserved.
//

import UIKit

class HTLiveAuthViewController: UIViewController {

    
    @IBOutlet weak var backImgV: UIImageView!
    @IBOutlet weak var forgroundImgV: UIImageView!
    
    private var vm = HTLiveVM()
    
    var complete: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func nameChanged(_ sender: UITextField) {
        vm.archor_name = sender.text ?? ""
    }
    
    @IBAction func idCardNumChanged(_ sender: UITextField) {
        vm.indentity_no = sender.text ?? ""
    }
    
    @IBAction func telChanged(_ sender: UITextField) {
        vm.telephone = sender.text ?? ""
    }
    
    @IBAction func uploadIdCardForground(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (image) in
            showHUD()
            HTAppVM.share.uploadImage(image, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.indentity_front = url
                    self.forgroundImgV.image = image
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func uploadIdCardBack(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (image) in
            showHUD()
            HTAppVM.share.uploadImage(image, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.indentity_background = url
                    self.backImgV.image = image
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func commitAction(_ sender: Any) {
        view.endEditing(true)
        vm.requestVerify { (success) in
            self.navigationController?.popViewController(animated: false)
            if let c = self.complete {
                c()
            }
        }
    }

    @IBAction func protocolAction(_ sender: Any) {
        // FIXME: 直播协议
        FYWebViewController.open("")
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
