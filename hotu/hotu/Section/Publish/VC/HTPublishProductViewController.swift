//
//  HTPublishProductViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/1.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishProductViewController: UIViewController {
    @IBOutlet weak var imgV: UIImageView!
    private var vm = HTPublishCourseVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        vm.model.type = "1"
        vm.requestPublishProduct { (success) in
            Toast("发布成功")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .HTProductChanged, object: nil)
        }
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        vm.model.name = sender.text ?? ""
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        vm.model.price = sender.text ?? ""
    }
    
    @IBAction func discountChanged(_ sender: UITextField) {
        vm.model.discountPrice = sender.text ?? ""
    }
    
    @IBAction func tagChanged(_ sender: UITextField) {
        vm.model.tag = sender.text ?? ""
    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
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
