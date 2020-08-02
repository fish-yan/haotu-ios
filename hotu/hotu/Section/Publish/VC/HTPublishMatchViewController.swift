//
//  HTPublishMatchViewController.swift
//  hotu
//
//  Created by 薛焱 on 2019/11/27.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

class HTPublishMatchViewController: UIViewController {
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var matchTypeTF: UITextField!
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var priceLab: UITextField!
    @IBOutlet weak var addLab: UITextField!
    @IBOutlet weak var mnLab: UITextField!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    @IBOutlet weak var anchorStatusLab: UILabel!
    @IBOutlet weak var anchorTF: UITextField!
    var vm = HTPublishMatchVM()
    
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdate {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem?.title = "申请"
            configView()
        }
    }
    
    func configView() {
        mnLab.text = vm.model.activityName
        dateTF.text = vm.model.startTime.formatDate("yyyy-MM-dd HH:mm:ss", to: "yyyy年MM月dd日HH时")
        addLab.text = vm.model.activityAddress
        matchTypeTF.text = vm.model.projectTypeName
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func publishAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        if isUpdate {
            vm.requestUpdateMatch { (success) in
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .HTMatchChanged, object: nil)
            }
        } else {
            vm.requestPublishMatch { (success) in
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .HTMatchChanged, object: nil)
            }
        }
        
    }
    @IBAction func matchNmChanged(_ sender: UITextField) {
        vm.model.activityName = sender.text ?? ""
    }
    
    @IBAction func dateAction(_ sender: UIButton) {
        view.endEditing(true)
        FYDatePicker.showDatePicker { (date) in
            self.dateTF.text = date.toString("yyyy年MM月dd日HH时")
            self.vm.model.startTime = date.toString("yyyy-MM-dd HH:mm:ss")
        }
    }
    @IBAction func addressChanged(_ sender: UITextField) {
        vm.model.activityAddress = sender.text ?? ""
    }
    
    @IBAction func priceChanged(_ sender: UITextField) {
        vm.model.m_visitor_amount = sender.text ?? ""
    }
    @IBAction func groupCountChange(_ sender: UITextField) {
        vm.model.total_no = sender.text ?? ""
    }
    
    @IBAction func anchorAction(_ sender: UIButton) {
        let vc = HTMemberListViewController()
        vc.type = 1
        vc.title = "主播"
        vc.selectedArr = vm.anchorList
        vc.complete = { models in
            self.vm.anchorList = models
            self.anchorTF.text = models.map({$0.nick_name}).joined(separator: ",")
            if models.isEmpty {
                self.anchorStatusLab.text = "非必填"
            } else {
                self.anchorStatusLab.text = "可重新选择"
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addPhotoAction(_ sender: UIButton) {
        view.endEditing(true)
        
        HTImagePickerUtil.share.pickerPhoto { (img) in
            showHUD()
            HTAppVM.share.uploadImage(img, isLogo: false) { (imgUrl) in
                hidHUD()
                if let url = imgUrl {
                    self.vm.model.sports_poster = url
                    self.imgV.image = img
                    let height = SCREEN_WIDTH / img.size.width * img.size.height
                    self.imgH.constant = height
                } else {
                    Toast("上传图片失败")
                }
            }
        }
    }
    
    @IBAction func deletePhotoAction(_ sender: UIButton) {
        self.vm.model.sports_poster = ""
        self.imgV.image = nil
        self.imgH.constant = 246
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HTItemList" {
            let vc = segue.destination as! HTItemListViewController
            vc.code = "PROJECT_TYPE"
            vc.complete = { item in
                self.vm.model.activityType = item.itemCode
                self.matchTypeTF.text = item.itemName
            }
        }
    }
    

}
