//
//  HTPublishCourseViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishCourseViewController: UIViewController {
  
    
    @IBOutlet weak var dateTF: UITextField!
    
    @IBOutlet weak var timeTF: UITextField!
    
    @IBOutlet weak var pLab: UILabel!
    
    @IBOutlet weak var imgV: UIImageView!

    private var vm = HTPublishCourseVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.model.type = "2"
        vm.requestPublishProduct { (success) in
            Toast("发布成功")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .HTCourseChanged, object: nil)
        }
    }

    @IBAction func titleChanged(_ sender: UITextField) {
        vm.model.name = sender.text ?? ""
    }
    
    @IBAction func countChanged(_ sender: UITextField) {
        vm.model.peopleNumber = sender.text ?? ""
    }
    
    @IBAction func amountChanged(_ sender: UITextField) {
        vm.model.price = sender.text ?? ""
    }
    
    @IBAction func addressChanged(_ sender: UITextField) {
        vm.model.address = sender.text ?? ""
    }
    
    @IBAction func dateAction(_ sender: Any) {
        view.endEditing(true)
        let calendar = FYCalendar.show()
        calendar.isSingle = true
        calendar.selectDateAction = { dates in
            let date = dates.first!
            self.vm.model.startTime = date.toString("yyyy-MM-dd") + " 00:00"
            self.dateTF.text = date.toString()
        }
    }
    
    @IBAction func timeAction(_ sender: Any) {
        view.endEditing(true)
        let calendar = FYCalendar.show()
        calendar.isSingle = true
        calendar.selectDateAction = { dates in
            let date = dates.first!
            self.vm.model.endTime = date.toString("yyyy-MM-dd") + " 00:00"
            self.timeTF.text = date.toString()
        }
    }
    
    @IBAction func tagChanged(_ sender: UITextField) {
        vm.model.tag = sender.text ?? ""
    }
    
    @IBAction func speChanged(_ sender: UITextField) {
        vm.model.properties = sender.text ?? ""
    }
    
    @IBAction func uploadImgAction(_ sender: UIButton) {
        view.endEditing(true)
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            HTAppVM.share.uploadImage(img, isLogo: true) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.model.img = url
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

extension HTPublishCourseViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        pLab.isHidden = !textView.text.isEmpty
        vm.model.remark = textView.text
    }
}
