//
//  HTCoachViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyCoachViewController: UIViewController {

    @IBOutlet weak var qualificationImgV: UIImageView!
    @IBOutlet weak var photoImgV: UIImageView!
    @IBOutlet weak var pLab: UILabel!
    
    private var vm = HTApplyCoachVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nameChanged(_ sender: UITextField) {
        vm.name = sender.text ?? ""
    }
    
    @IBAction func nickNameChanged(_ sender: UITextField) {
        vm.nick_name = sender.text ?? ""
    }
    
    @IBAction func telChanged(_ sender: UITextField) {
        vm.telephone = sender.text ?? ""
    }
    
    @IBAction func uploadPhotoImgAction(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            guard let aimg = img.archive(size: 100) else {return}
            HTAppVM.share.uploadImage(aimg, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.identity_certificate = url
                    self.photoImgV.image = img
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func uploadQualicationImgAction(_ sender: UIButton) {
        HTImagePickerUtil.share.pickerPhoto { (image) in
            showHUD()
            HTAppVM.share.uploadImage(image, isLogo: false) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.qualification_certificate = url
                    self.qualificationImgV.image = image
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.requestApplyCoach { (success) in
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.coach])
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

extension HTApplyCoachViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = !textView.text.isEmpty
        vm.remark = textView.text
    }
}
