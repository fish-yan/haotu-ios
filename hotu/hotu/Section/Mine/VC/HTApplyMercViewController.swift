//
//  HTApplyMercViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/30.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTApplyMercViewController: UIViewController {
    @IBOutlet weak var pLab: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    private  var vm = HTApplyMercVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.requestApplyMerc { (success) in
            NotificationCenter.default.post(name: .HTRoleChanged, object: [HTNotificationKey.role: HTRoleType.merc])
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        vm.business_name = sender.text ?? ""
    }
    
    @IBAction func addressChanged(_ sender: UITextField) {
        vm.business_address = sender.text ?? ""
    }
    
    @IBAction func cntNmChanged(_ sender: UITextField) {
        vm.name = sender.text ?? ""
    }
    
    @IBAction func cntTelChanged(_ sender: UITextField) {
        vm.telephone = sender.text ?? ""
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            guard let aimg = img.archive(size: 100) else {return}
            HTAppVM.share.uploadImage(aimg, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.business_logo = url
                    self.imgV.image = img
                } else {
                    Toast("上传图片失败")
                }
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

extension HTApplyMercViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = !textView.text.isEmpty
        vm.remark = textView.text
    }
}
