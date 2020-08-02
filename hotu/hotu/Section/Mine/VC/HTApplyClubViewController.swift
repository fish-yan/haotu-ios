//
//  HTClubViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyClubViewController: UIViewController {

    @IBOutlet weak var pLab: UILabel!
    @IBOutlet weak var logoImgV: UIImageView!
    
    var vm = HTApplyClubVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clubNmChanged(_ sender: UITextField) {
        vm.group_name = sender.text ?? ""
    }
    
    @IBAction func cntNmChanged(_ sender: UITextField) {
        vm.publish_name = sender.text ?? ""
    }
    
    @IBAction func cntTelChanged(_ sender: UITextField) {
        vm.publish_telphone = sender.text ?? ""
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            guard let aimg = img.archive(size: 100) else {return}
            HTAppVM.share.uploadImage(aimg, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.group_logo = url
                    self.logoImgV.image = img
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.requestApplyClub { (success) in
            NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.club])
            self.navigationController?.popToRootViewController(animated: true)
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

extension HTApplyClubViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = textView.text.count != 0
        vm.remark = textView.text
    }
}
