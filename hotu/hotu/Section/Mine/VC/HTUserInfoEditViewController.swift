//
//  HTUserInfoEditViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/7.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTUserInfoEditViewController: UIViewController {

    @IBOutlet weak var signTF: UITextField!
    @IBOutlet weak var nickTF: UITextField!
    @IBOutlet weak var birthTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idcardTF: UITextField!
    @IBOutlet weak var telTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var imgV: UIImageView!
    
    var headerUrl = HTUserInfo.share.headerImg
    
    var signText = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        nickTF.text = HTUserInfo.share.userName
        self.signTF.text = signText.isEmpty ? "" : "已编辑"
        imgV.sd_setImage(with: URL(string: HTUserInfo.share.headerImg), completed: nil)
    }
    
    @IBAction func birthAction(_ sender: UIButton) {
        view.endEditing(true)
        FYDatePicker.showDatePicker { (date) in
            self.birthTF.text = date.toString("yyyy-MM-dd")
        }
    }
    
    @IBAction func sendCodeAction(_ sender: HTCutdownBtn) {
        view.endEditing(true)
        guard let tel = telTF.text,
            tel.isPhone() else {
                Toast("请输入正确的手机号码")
                return
        }
        HTAppVM.share.requestGetCode(tel: tel) { (success) in
            sender.cutDown()
            self.codeTF.becomeFirstResponder()
        }
    }
    
    @IBAction func uploadPhotoAction(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            guard let aimg = img.archive(size: 100) else {return}
            HTAppVM.share.uploadImage(img, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.imgV.image = img
                    self.headerUrl = url
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func commitAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        requestUpdateUserInfo { (success) in
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .HTUserInfoChanged, object: nil)
        }
    }
    
    @IBAction func tvAction(_ sender: UIButton) {
        performSegue(withIdentifier: "HTTextView", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTTextView" {
            let vc = segue.destination as! HTTextViewViewController
            vc.text = signText
            vc.complete = { text in
                self.signText = text
                self.signTF.text = text.isEmpty ? "" : "已编辑"
            }
        }
    }    
}

extension HTUserInfoEditViewController {
    func requestUpdateUserInfo(complete: @escaping(Bool)->Void) {
        guard let nickName = nickTF.text,
            !nickName.isEmpty  else {
                Toast("请填写名字")
                return
        }
        
        let params = ["nick_name": nickName,
                      "userLogo":headerUrl,
                      "autograph":self.signText]
        FYNetWork.request(EDIT_USER_INFO, params: params).responseJSON { (response: HTBaseModel<String>) in
            Toast("修改成功")
            complete(true)
        }
    }
}
